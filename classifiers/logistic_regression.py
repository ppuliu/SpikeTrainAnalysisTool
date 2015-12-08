################################################################
# This implementation is adopted from 
# http://deeplearning.net/software/theano/tutorial/examples.html
#
################################################################
import sys
import numpy as np
import theano
import theano.tensor as T
import matplotlib.pyplot as plt
rng = np.random


class  logistic_regression():
	"""classifier based on logistic regression  """

	def __init__(self,n_features):

		# Declare Theano symbolic variables
		x = T.matrix("x")
		y = T.vector("y")

		self.w = theano.shared(rng.randn(n_features), name="w")
		self.b = theano.shared(0., name="b")
		print("Initial model:")
		print(self.w.get_value())
		print(self.b.get_value())

		# Construct Theano expression graph
		p_1 = 1 / (1 + T.exp(-T.dot(x, self.w) - self.b))   # Probability that target = 1
		prediction = p_1 > 0.5                    # The prediction thresholded
		xent = -y * T.log(p_1) - (1-y) * T.log(1-p_1) # Cross-entropy loss function
		cost = xent.mean() + 0.01 * (self.w ** 2).sum()# The cost to minimize
		gw, gb = T.grad(cost, [self.w, self.b])             # Compute the gradient of the cost
		                                          # (we shall return to this in a
		                                          # following section of this tutorial)

		# Compile
		self.theano_train = theano.function(
		          inputs=[x,y],
		          outputs=[prediction, cost],
		          updates=((self.w, self.w - 0.1 * gw), (self.b, self.b - 0.1 * gb)))
		self.theano_predict = theano.function(inputs=[x], outputs=prediction)


	def train(self, x, y, max_iter=2000):

		last_err=0
		# Train
		for i in xrange(max_iter):
		    pred, err = self.theano_train(x, y)
		    print '{0} : {1}'.format(i, err)

		    if abs(err-last_err)<1e-6:
		    	print('early termination')
		    	break
		    last_err=err

		print("Final model:")
		print(self.w.get_value())
		print(self.b.get_value())
		print("target values:")
		print(y)
		print("prediction on y:")
		print(pred)

		return pred,err

	def predict(self, x, y):
		
		pred=self.theano_predict(x)
		print("target values:")
		print(y)
		print("prediction on y:")
		print(pred)

		misclass_rate=float((abs(pred-y)).sum())/len(y)
		print('mis-classification rate:')
		print(misclass_rate)
		return pred, misclass_rate


############################## helper functions #######################

def load_data(file_name):

	ids=[]
	features=[]
	with open(file_name) as f:
		for line in f:
			if line.startswith('#'):
				continue

			fields=line.split()
			record_id=fields[0].strip()

			###### temporary #####
			t=record_id.split('_');
			record_id=t[1]+'_'+t[2];
			######

			data=map(float,fields[1:])

			ids.append(record_id)
			features.append(data)


	return np.array(features), ids


def combine_data(file_name1, file_name2):

	(x1,t)=load_data(file_name1)	# control
	y1=np.zeros([x1.shape[0],])
	(x2,t)=load_data(file_name2)	# target
	y2=np.ones([x2.shape[0],])

	x=np.concatenate((x1,x2))
	y=np.concatenate((y1,y2))

	# normalization
	# subtract mean, divide by max
	t1=np.ones([x.shape[0],1])
	t2=x.mean(axis=0).reshape([x.shape[1],1]).T
	x-=np.dot(t1,t2)

	t2=abs(x).max(axis=0).reshape([x.shape[1],1]).T
	x/=np.dot(t1,t2)

	return x,y

def shuffle_n_train(x,y, ratio):

	(n_sample, n_features)=x.shape

	n_train=int(n_sample*ratio)
	n_test=n_sample-n_train

	y=y.reshape([y.shape[0],1])
	xy=np.concatenate((x,y),axis=1)

	rng.shuffle(xy)

	train_x=xy[:n_train,:-1]
	train_y=xy[:n_train,-1]

	test_x=xy[n_train:,:-1]
	test_y=xy[n_train:,-1]

	logis=logistic_regression(x.shape[1])
	logis.train(train_x,train_y)

	pred, misclass_rate=logis.predict(test_x,test_y)

	return misclass_rate



def repate_train(file_name1,file_name2,ratio,repeat_n):

	misrates=[]

	x,y=combine_data(file_name1,file_name2)

	for i in xrange(repeat_n):
		print '-------------{0}--------------'.format(i)
		misrates.append(shuffle_n_train(x,y,ratio))

	plt.scatter(range(len(misrates)), misrates, marker = 'o', c = 'red',s=200,label='Control')
	plt.ylabel('mis-classification rate')
	plt.show()


if __name__ == '__main__':

	#x,y=combine_data(sys.argv[1],sys.argv[2])
	#shuffle_n_train(x,y,0.5)

	# D = (rng.randn(400, 784), rng.randint(size=400, low=0, high=2))
	# x=D[0]
	# y=D[1]
	#logis=logistic_regression(x.shape[1])
	#logis.train(x,y)

	repate_train(sys.argv[1],sys.argv[2],0.5,100)
