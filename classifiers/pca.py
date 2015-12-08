import sys
import os
import numpy as np
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt


def read_features(files):
	'''
	read features, return a matrix with row names
	'''
	ids=[]
	features=[]
	nrecords=[]

	for file_name in files:
		print file_name
		nfeature=0
		with open(file_name) as f:
			for line in f:
				if line.startswith('#'):
					continue

				fields=line.split()
				record_id=fields[0].strip()

				###### temporary #####
				t=record_id.split('_');
				record_id=t[1]+t[2]+'_'+t[3];
				######

				data=map(float,fields[1:])
				nfeature+=1

				ids.append(record_id)
				features.append(data)

		nrecords.append(nfeature)

	x=np.array(features)
	# normalization
	# subtract mean, divide by max
	t1=np.ones([x.shape[0],1])
	t2=x.mean(axis=0).reshape([x.shape[1],1]).T
	x-=np.dot(t1,t2)

	t2=abs(x).max(axis=0).reshape([x.shape[1],1]).T
	norm=np.dot(t1,t2)+1e-9
	x/=norm

	return ids, x, nrecords[0]

def pca(M,n_componets):

	pca = PCA(n_components=n_componets)
	transM = pca.fit_transform(M)

	return transM  # recording number x n_componets

def run(files,plotfig):

	ids, features, ncotrol=read_features(files)

	transM = pca(features,2)

	if plotfig:

		# plot control

		plt.scatter(transM[0:ncotrol,0], transM[0:ncotrol, 1], marker = 'o', c = 'red',s=200,label='Control')
		for label, x, y in zip(ids[0:ncotrol], transM[0:ncotrol,0], transM[0:ncotrol, 1]):
		    plt.annotate(
		        label,xy = (x, y))
		      	# xytext = (-20, 20),
		       #  textcoords = 'offset points', ha = 'right', va = 'bottom',
		       #  bbox = dict(boxstyle = 'round,pad=0.5', fc = 'yellow', alpha = 0.5),
		       #  arrowprops = dict(arrowstyle = '->', connectionstyle = 'arc3,rad=0'))


		# plot target

		plt.scatter(transM[ncotrol:,0], transM[ncotrol:, 1], marker = 'o', c = 'blue',s=200,label='Tau')
		for label, x, y in zip(ids[ncotrol:], transM[ncotrol:,0], transM[ncotrol:, 1]):
		    plt.annotate(
		        label, xy = (x, y))

		plt.legend()
		plt.show()

	return transM




if __name__ == '__main__':
	'''
	[1].. feature files for control and target
	'''

	files=sys.argv[1:]
	run(files,True)