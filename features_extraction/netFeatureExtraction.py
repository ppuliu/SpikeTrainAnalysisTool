import sys
import math
import os
import numpy as np

import networkx as nx


features_list=['degree_pearson_correlation_coefficient','betweenness_centrality', \
				'load_centrality', \
				'average_shortest_path_length', \
				'self_explanation_ratio', 'average_node_degree','mean_of_weights','median_of_weights','variance_of_weights']


def get_files(dir_path):
	'''
	get all the txt files in a directory
	'''

	files = [f for f in os.listdir(dir_path) if f.endswith('.txt')]

	return files

def build_graph(M):
	'''
	get networkx object
	'''
	g=nx.DiGraph()

	m=len(M)
	for i in xrange(m):
		to_idx=i+1
		for j in xrange(m):
			from_idx=j+1
			weight=M[i,j]
			if abs(weight)>0:
				g.add_edge(from_idx,to_idx,weight=abs(weight))

	return g

def extract_featuers(g,M):
	'''
	extract network features
	'''

	features=[]
	
	features.append(nx.degree_pearson_correlation_coefficient(g,weight='weight'))

	t=nx.betweenness_centrality(g,weight='weight')
	features.append(sum(t.values())/len(t))


	t=nx.load_centrality(g,weight='weight')
	features.append(sum(t.values())/len(t))

	features.append(nx.average_shortest_path_length(g,weight='weight'))

	features.append(get_self_expl_ratio(M))

	features.append(get_average_degree(M))

	features.append(get_mean(M))
	
	features.append(get_median(M))

	features.append(get_variance(M))

	features.append(get_negative_ratio(M))

	return features



def get_average_degree(M):
	'''
	get the average node degree
	'''	
	total=sum(sum(M))

	n=len(M)

	return total/n

def get_mean(M):
	'''
	return mean
	'''

	return np.mean(M)


def get_variance(M):
	'''
	return variance
	'''

	return np.var(M)

def get_median(M):
	'''
	return median
	'''

	return np.median(M)

def get_self_expl_ratio(M):
	'''
	return self explanation ratio
	'''

	total=sum(sum(abs(M)))
	self_sum=sum(sum(abs(M)*np.identity(len(M))))

	print self_sum/total

	return self_sum/total

def get_negative_ratio(M):
	'''
	return the ratio of negative degrees
	'''
	negative=abs(sum(sum(M*(M<0))))
	total=sum(sum(abs(M)))

	return negative/total


def get_weight_matrix(file_path,weight_filter):

	M=np.loadtxt(file_path)
	M[np.isnan(M)] = 0

	if weight_filter==1:
		print 'positive filter'
		M=M*(M>0)
	elif weight_filter==-1:
		print 'negative filter'
		M=M*(M<0)

	M/=abs(M).max()

	return M


def run(input_dir, output_file, weight_filter):
	'''
	weight_filter : 0	keep all the weights
					1	kepp only the positive weights
					-1	kepp only the negative weights
	'''

	with open(output_file,'w') as f:
		f.write('#'+'\t'.join(features_list))
		f.write('\n')
		file_names=get_files(input_dir)
		for name in file_names:
			file_path=os.path.join(input_dir,name)
			print 'processing {0}'.format(file_path)

			M=get_weight_matrix(file_path,weight_filter)
			g=build_graph(M)

			features=extract_featuers(g,M)

			record_id = os.path.splitext(name)[0]

			f.write(record_id+'\t'+'\t'.join(map(str,features)))
			f.write('\n')



if __name__=='__main__':
	'''
	[1] weight matrix files' directory
	[2] output file
	[3] weight_filter -1/0/1
	'''

	input_dir=sys.argv[1]
	output_file=sys.argv[2]
	weight_filter=int(sys.argv[3])

	run(input_dir, output_file,weight_filter)


