import sys
import math
import os
import numpy as np

import networkx as nx


features_list=['degree_assortativity_coefficient','degree_pearson_correlation_coefficient','betweenness centrality', /
				'current_flow_closeness_centrality','current_flow_betweenness_centrality','load centrality',/
				'clustering coefficient','average shortest path length',/
				'self explanation ratio', 'average node degree','mean of weights','median of weights','variance of weights']


def get_files(dir_path):
	'''
	get all the txt files in a directory
	'''

	files = [f for f in os.listdir(dir_path) if f.endswith('.txt')]

	return files

def build_graph(matrix_file):
	'''
	get networkx object
	'''
	g=nx.DiGraph()

	with open(matrix_file) as f:
		to_idx=0
		for line in f:
			to_idx+=1
			fields=line.split();
			for i in xrange(len(fields)):
				from_idx=i+1
				weight=float(fields[i])
				if abs(weight)>0:
					g.add_edge(from_idx,to_idx,weight=abs(weight))

	return g

def extract_featuers(g,M):
	'''
	extract network features
	'''

	features=[]

	features.append(nx.degree_assortativity_coefficient(g,weight='weight'))
	
	features.append(nx.degree_pearson_correlation_coefficient(g,weight='weight'))

	t=nx.betweenness_centrality(g,weight='weight')
	features.append(sum(t.values())/len(t))

	t=nx.current_flow_closeness_centrality(g,weight='weight')
	features.append(sum(t.values())/len(t))	

	t=nx.current_flow_betweenness_centrality(g,weight='weight')
	features.append(sum(t.values())/len(t))

	t=nx.load_centrality(g,weight='weight')
	features.append(sum(t.values())/len(t))

	features.append(nx.average_clustering(g,weight='weight'))

	features.append(nx.average_shortest_path_length(g,weight='weight'))

	features.append(get_self_expl_ratio(M))

	features.append(get_average_degree(M))

	features.append(get_mean(M))
	
	features.append(get_median(M))

	features.append(get_variance(M))

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

	total=sum(sum(M))
	self_sum=sum(sum(M*np.identity(len(M))))

	return self_sum/total


def run(input_dir, output_file):

	with open(output_file,'w') as f:
		f.writeline('#'+'\t'.join(features_list))
		file_names=get_files(input_dir)
		for name in file_names:
			file_path=os.path.join(input_dir,name)
			print 'processing {0}'.format(file_path)

			g=build_graph(file_path)
			M=np.load(file_path)

			features=extract_featuers(g,M)

			record_id = os.path.splitext(name)[0]

			f.writeline('record_id\t'+'\t'.join(map(str,features_list)))



if __name__=='__main__':
	'''
	[1] weight matrix files' directory
	[2] output file
	'''

	input_dir=sys.argv[0]
	output_file=sys.argv[1]

	run(input_dir, output_file)


