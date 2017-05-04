#!/usr/bin/python

import sys
import Servo_Control as servo

def main():
	# main program code
	print("Hello, my name is Arthur. How can I help you?") #intro message
	
	# variables used throughout
	choice = 0
	
	# main loop in code
	while True:
		print('1. Home arm')
		print('2. Manual')
		print('3. Programmed movements')
		print('To quit put in any non-integer.')
		choice = raw_input('>> ')
		# checks for valid integer input
		try:
			choice = int(choice)
		except ValueError:
			print('Thank you, Goodbye.')
			exit()
		servo.Action(int(choice)) # do operation
		
	#channel = raw_input('channel # (1-5): ')
	#value = raw_input('percentage # (1-100): ')
	#print('{} {}'.format(channel,value))

if __name__ == "__main__":
	main()
