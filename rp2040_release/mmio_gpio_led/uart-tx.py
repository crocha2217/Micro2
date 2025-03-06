import dataclasses

import gdb
import numpy as np
from PIL import Image


class uart_tx(gdb.Command):
	def __init__(self):
		self.__serial = '/dev/ttyACM0'
		self.__baud = 115200
		self.__cmds = {
				'send':		self.__send,
				'recv':		self.__recv,
				'port':		self.__port,
				'open':		self.__open,
				'close':	self.__close,
				'load-img':	self.__load_img,
				'send-next':	self.__send_next
			}
		self.__image = None
		self.__uart = None

		super().__init__('uart-tx', gdb.COMMAND_SUPPORT)

	def invoke(self, args, tty):
		args = gdb.string_to_argv(args)
		if len(args) == 0:
			gdb.write(f'subcommand required\n')
			return

		invalid = lambda x: gdb.write(f'invalid subcommand {args[0]}\n')

		self.__cmds.get(args[0], invalid)(args[1:])

	@dataclasses.dataclass
	class __regex_match(object):
		string: str
		def __eq__(self, other):
			import re
			if isinstance(other, str): other = re.compile(other)
			return other.fullmatch(self.string) is not None

	class __image_handler(object):
		def __init__(self, file, img_type=0):
			with Image.open(file) as img:
				fig = np.array(img.convert('1'))
			self.__img_type = img_type
			self.__payload = self.__make_payload(fig)
			self.__idx = 0
	
		def __make_payload(self, fig):
			return {
						0:	self.__make_scrolling,
						1:	self.__make_animated
					}[self.__img_type](fig)
	
		def __make_scrolling(self, fig):
			collapse = lambda col: sum([x << i for i, x in enumerate(col)])	
			# trim for length
			size = (fig.shape[1] if fig.shape[1] < 0x300 else 0x300) - 1

			# create the payload
			payload = np.empty(size + 5, dtype=np.uint8)
	
			# set the header and size
			payload[0:3] = 0x46, size >> 8, size & 0xff
	
			# fill in the column data
			for i in range(size + 1):
				# in the worst way possible
				payload[i + 3] = collapse(fig[:,i]) & 0xff
	
			# checksum computation in a way ancient versions of python do not
			# throw a fit whilst performing the operation
			payload[-1] = (-int(np.sum(payload[1:-1]))) & 0xff
	
			return payload

		def __make_animated(self, fig):
			pass
	
		def __iter__(self):
			return self

		def __next__(self):
			if self.__idx == self.__payload.size:
				raise StopIteration

			value = self.__payload[self.__idx]
			self.__idx += 1
			return value

	def __get_base(self, value):
		match self.__regex_match(value):
			case r"[1-9][0-9]*":		return 10
			case r"(0b)?[01]+":			return 2
			case r"(0x)?[0-9a-fA-F]+":	return 16
			case _:	return None

	def __get_value(self, value):
		if isinstance(value, int): return value
		base = self.__get_base(value)
		if base is not None: return int(value, base)

		return None

	def __send(self, args):
		if not self.__uart or not self.__uart.is_open:
			gdb.write('serial port not open\n')
			return
		data = [self.__get_value(x) for x in args]
		if len([x for x in data if x is not None and x > 255]):
			gdb.write('list contains non-byte sized value\n')
			return
		if None in data:
			gdb.write(f'invalid value {args[data.index(None)]}\n')
			return
		# XXX: data element can be over 255 in value
		self.__uart.write(bytearray(data))

	def __recv(self, args):
		gdb.write(f'recv {args}\n', gdb.STDERR)

	def __load_img(self, args):
		if len(args) != 1:
			gdb.write(f'uart-tx load-img filename')
			return
		import os
		file = os.path.expanduser(args[0])
		self.__image = self.__image_handler(file)

	def __send_next(self, args):
		if not self.__image:
			gdb.write('no image loaded\n')
			return

		try:
			value = next(self.__image)
			self.__send([value])
		except StopIteration:
			gdb.write(f'nothing to send\n')

	def __port(self, args):
		match len(args):
			case 0:	gdb.write(f'{self.__serial} {self.__baud} 8N1\n')
			case 1: self.__serial = args[0]
			case 2:
				if self.__get_base(args[1]) != 10:
					gdb.write(f'invalid BAUD {args[1]}\n')
					return
				self.__serial = args[0]
				self.__baud = int(args[1])
			case _: gdb.write('too many arguments\n')

	def __open(self, args):
		import serial
		if self.__uart and self.__uart.is_open:
			gdb.write('port already open\n')
			return
		self.__uart = serial.Serial(port=self.__serial, baudrate=self.__baud)

	def __close(self, args):
		if self.__uart and self.__uart.is_open: self.__uart.close()

	def complete(self, text, word):
		argv = gdb.string_to_argv(text)
		argc = len(argv)

		if argc == 0:
			return list(self.__cmds.keys())

		if argc == 1 and word:
			return [x for x in self.__cmds.keys() if x.startswith(word)]

		if argc == 1 and not word:
			if argv[0] == "load-img": return gdb.COMPLETE_FILENAME
			# XXX: ugly code, fix later
			elif argv[0].startswith('send-') and argv[0] != "send-next":
				return ['send-next'[len(argv[0]):] ]
			return gdb.COMPLETE_NONE

		if argc == 2:
			if argv[0] == "load-img": return gdb.COMPLETE_FILENAME

		return gdb.COMPLETE_NONE

uart_tx()
