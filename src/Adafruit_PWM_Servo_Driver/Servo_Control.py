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
		home
		time.delay(1)
		print(
	elif choice == 2:
		print('NOT implemented')
	else
		print('NOT implemented')

def setServoPulse(channel, pulse):
  pulseLength = 1000000                   # 1,000,000 us per second
  pulseLength /= 60                       # 60 Hz
  print "%d us per period" % pulseLength
  pulseLength /= 4096                     # 12 bits of resolution
  print "%d us per bit" % pulseLength
  pulse *= 1000
  pulse /= pulseLength
  pwm.setPWM(channel, 0, pulse)

def setAngle(channel, value):
	# check if value is between between right value for channel
	if checkValue(channel,value):
		return
	pwm.setPWMFreq(60) # Set frequency to 60 Hz
	fraction = int(servoMin + (value/100.0)*(servoMax - servoMin))
	print('setting servo {} to {}'.format(channel, fraction))
	pwm.setPWM(channel,0,fraction)
	time.sleep(1)

def checkValue(channel,value):
	# returns a boolean for id value is on the proper range for the channel
	if checkChannel(channel):
		return true
	else:
		print('Not a valid channel, must be (1-4)')
		return false
	
	return true

def checkChannel(channel):
	return {
		1:true,
		2:true,
		3:true,
		4:true,
	}.get(channel,false)
