import numpy as np
import matplotlib.pyplot as plt
from puflib import ResponseBuffer


def GetCoverage(BigBuffer):
	
	X 		= [0] * (len(BigBuffer))
	Xsum  = [0] * (len(BigBuffer[0]))
	
	Challenges = len(BigBuffer[0])

	for Challenge in range(Challenges):
		
		for Dev1 in range(len(BigBuffer)):
			if X[Dev1] == 0:
				Unique = True
				for Dev2 in range(len(BigBuffer)):
					if Dev1 != Dev2:
						if X[Dev2] == 0:
							ChalUnique = False
							for Chal in range(Challenge):
								if BigBuffer[Dev1][Chal] !=BigBuffer[Dev2][Chal]:
									ChalUnique = True
							if ChalUnique == False:
							
								Unique = False
				if Unique:
					X[Dev1] = 1
		
		Xsum[Challenge] += X.count(1)
		
	return Xsum			

		
		
if __name__ == "__main__":

	Response0 = open("/root/Dropbox/IC/puf_simulation/trunk/modules/new-crpuf/data/PUF_Response/Signature_PUF_3x3_bits_100_pufs.txt", "r")
	Response1 = open("/root/Dropbox/IC/puf_simulation/trunk/modules/new-crpuf/data/PUF_Response/CRPUF1_response_PUF_3x3_bits_100_pufs.txt", "r")
	Response2 = open("/root/Dropbox/IC/puf_simulation/trunk/modules/new-crpuf/data/PUF_Response/CRPUF2_response_PUF_3x3_bits_100_pufs.txt", "r")
	
	
	Buffer = ResponseBuffer().BufferSignal(Response0).Responses
	x = GetCoverage(Buffer)
	
	print x
	plt.plot(range(len(Buffer[0])), x,label="Signature")


	Buffer = ResponseBuffer().BufferSignal(Response1).Responses
	x = GetCoverage(Buffer)
	
	print x
	plt.plot(range(len(Buffer[0])), x,label="CRPUF1")


	Buffer = ResponseBuffer().BufferSignal(Response2).Responses
	x = GetCoverage(Buffer)	

	print x
	plt.plot(range(len(Buffer[0])), x,label="CRPUF2")

#	plt.ylim(10000)	
	plt.xlim(0, 16)
	
	plt.grid(True)
	plt.legend()
	
	plt.show()
