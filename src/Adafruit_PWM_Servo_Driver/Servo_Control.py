#!/usr/bin/python
import sys
from Adafruit_PWM_Servo_Driver import PWM
import time

# ===========================================================================
# Example Code
# ===========================================================================

# Initialise the PWM device using the default address
pwm = PWM(0x40)
# Note if you'd like more debug output you can instead run:
#pwm = PWM(0x40, debug=True)

servoMin = 150  # Min pulse length out of 4096
servoMax = 600  # Max pulse length out of 4096

def Action(choice):
	# chooses a specific action based off of user choice

	# checks range of value
	if choice < 1 or choice > 3:
		print('Not within range of choices.')
		return
	
	# chooses action
	if choice == 1:
		# home the arm
		home()
		time.sleep(1)
		
	elif choice == 2:
		#manual control of the arm
		manualSet()
	else:
		while True:
			print('1. Say Yes!')
			print('2. Retreive A')
			print('3. Retreive B')
			print('4. Choose Location')
			print('To quit put in any non-integer.')
			choice = raw_input('>> ')
			
			# checks for valid integer input
			try:
				choice = int(choice)
			except ValueError:
				return
			manualActions(int(choice)) # do operation

def setServoPulse(channel, pulse):
  pulseLength = 1000000                   # 1,000,000 us per second
  pulseLength /= 60                       # 60 Hz
  print "%d us per period" % pulseLength
  pulseLength /= 4096                     # 12 bits of resolution
  print "%d us per bit" % pulseLength
  pulse *= 1000
  pulse /= pulseLength
  pwm.setPWM(channel, 0, pulse)

def setAngle(channel, deg):
	# convert degrees to a percentage of motion
	value = deg/1.8
	value = checkValue(channel,value)
	# check if value is between between right value for channel
	if value == -1:
		return
	pwm.setPWMFreq(60) # Set frequency to 60 Hz
	if channel == 5:
		pulse = 102.375
		pwm.setPWM(channel, 0, int(pulse))
		pwm.setPWMFreq(50)
		
	#actually sets the servo value to the percentage
	fraction = int(servoMin + (value/100.0)*(servoMax - servoMin))
	print('setting servo {} to {}'.format(channel, fraction))
	pwm.setPWM(channel,0,fraction)
	time.sleep(0.1)

def checkValue(channel,value):
	# returns a boolean for if value is on the proper range for the channel
	if not(checkChannel(channel)):
		print('Not a valid channel, must be (1-5)')
		return -1
	else:
		if channel == 1:
			# servo 1
			if value > 88:
				value = 88
			elif value < 0:
				value = 0
		elif channel == 2:
			# servo 2
			if value > 70:
				value = 70
			elif value < 18:
				value = 18
		elif channel == 3:
			# servo 3
			if value > 78:
				value = 78
			elif value < 24:
				value = 24
		else:
			# servo 4
			if value > 100:
				value = 100
			elif value < 0:
				value = 0
		
		return value
	
	return True

def checkChannel(channel):
	return {
		1:True,
		2:True,
		3:True,
		4:True,
		5:True,
	}.get(channel,False)
	
def home():
	# set angles for all servos
	# angle values must be from 0 to 180 
	setAngle(1, 90)
	setAngle(2, 126)
	setAngle(3, 48)
	setAngle(4, 0)
	
def powerDown():
	setAngle(4, 0)
	
def manualSet():
	while(True):
		channel = raw_input('choose channel (input character to exit) >> ')
		# checks for valid integer input
		try:
			choice = int(channel)
		except ValueError:
			return
		deg = raw_input('choose degrees >> ')
		setAngle(int(channel), int(deg))

def manualActions(choice):
	if choice == 1:
		home()
		
		# do the nodding
		setAngle(3, 81)
		time.sleep(0.)
		setAngle(3, 48)
		time.sleep(0.2)
		setAngle(3, 81)
		time.sleep(0.2)
		setAngle(3, 48)
		time.sleep(0.2)
		setAngle(3, 81)
		time.sleep(0.2)
		setAngle(3, 48)
		
	elif choice == 2:
		#programmed movement 1
		home() #home the arm
		time.sleep(0.3)
		setAngle(2, 35)
		time.sleep(2)
		setAngle(2, 126)
		
	elif choice == 3:
		#programmed movement 2
		home()
		#rotate
		time.sleep(0.3)
		setAngle(1, 0)
		#grab 		
		setAngle(2, 35)
		time.sleep(2)
		setAngle(2, 126)
		
		setAngle(1, 90)
	else:
		print('not finished implementing')

		
