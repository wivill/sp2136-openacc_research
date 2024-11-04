# -*- coding: utf-8 -*-
# Imports and definitions
import datetime as dt
import untangle as utan
import matplotlib.pyplot as plt
import re

# adds a global root to the log file to make it xml standard compliant
def line_prepender(filename, first_line, end_line):
	with open(filename, 'r+') as f:
		content = f.read()
		f.seek(0,0)
		f.write(first_line.rstrip('\r\n') + '\n' + content)
	with open(filename, 'a') as f:
    		f.write(end_line + '\n')

# Generates the log file name to be parsed
def gen_logname():
	return dt.date.today().strftime('%Y%m%d')

# Collects global usage data from torque log files.
def get_global_data(log):
	walltime = 0
	for i in range(len(log.parent.Jobinfo)):
		while True:
			try:
				walltime = walltime + int(log.parent.Jobinfo[i].resources_used.walltime.cdata)
				break
			except IndexError:
				break
	return walltime

# Collects specified queue usage data from torque log files.
def get_queue_data(log, queue):
	walltime = 0
	for i in range(len(log.parent.Jobinfo)):
		while True:
			try:
				if log.parent.Jobinfo[i].queue.cdata == queue:
					walltime = walltime + int(log.parent.Jobinfo[i].resources_used.walltime.cdata)
					break
				else:
					break
			except IndexError:
				break
	return walltime

# Collects specified node usage data from torque log files.
def get_node_data(log, node):
	walltime = 0
	for i in range(len(log.parent.Jobinfo)):
		while True:
			try:
				if log.parent.Jobinfo[i].exec_host.cdata.count(node) >= 1:
					walltime = walltime + int(log.parent.Jobinfo[i].resources_used.walltime.cdata)
					break
				else:
					break
			except IndexError:
				break
	return walltime

# Collects users data from torque log files.
def get_user_data(log, user):
	walltime = 0
	for i in range(len(log.parent.Jobinfo)):
		while True:
			try:
				if log.parent.Jobinfo[i].Job_Owner.cdata.count(user) >= 1:
					walltime = walltime + int(log.parent.Jobinfo[i].resources_used.walltime.cdata)
					break
				else:
					break
			except IndexError:
				break
	return walltime

# Gets users from log file and creates a dictionary
def user_dict(log):
	user = {}
	for i in range(len(log.parent.Jobinfo)):
		while True:
			try:
				# Extracts the user name from the log file and assings it as a dictionary key with default value 0
				user[re.search('(.+?)@', log.parent.Jobinfo[i].Job_Owner.cdata).group(1)] = 0
				break
			except IndexError:
				break
			except AttributeError:
				break
	return user

# Extracts and manipulates data from log files
def main():
	# Normalization variables
	su_cadejos = 432000 # Seconds or 120 hours/Service Units per day
	su_zarate = 345600 # Seconds or 96 hours/Service Units per day
	su_total = su_cadejos + su_zarate

	# Defines log file name and parses it
	log_file = gen_logname()
	# line_prepender(log_file, '<parent>', '</parent>')
	log = utan.parse(log_file)

	# Creates dictionaries
	users = user_dict(log)
	nodes = {'cadejos-0':0, 'cadejos-1':0, 'cadejos-2':0, 'cadejos-3':0, 'cadejos-4':0, 'phi-a':0, 'phi-b':0, 'phi-c':0, 'phi-d':0}
	queues = {'total':0, 'cadejos':0, 'zarate':0, 'cpu-debug':0, 'cpu-n4h24':0, 'cpu-n3h72':0, 'gpu-debug':0, 'gpu-n2h24':0, 'gpu-n1h72':0, 'phi-debug':0, 'phi-n2h72':0, 'phi-n3h24':0, 'debug':0, 'n3h72':0, 'n4h24':0}

	# Gets data using defined functions and normalices data to Service Units (SU)
	for i in queues.keys():
		queues[i] = (get_queue_data(log, i))/3600

	for i in users.keys():
		users[i] = (get_user_data(log, i))/3600

	for i in nodes.keys():
		nodes[i] = (get_node_data(log, i))/3600

	queues['cadejos'] = queues['cpu-debug'] + queues['debug'] + queues['cpu-n4h24'] + queues['cpu-n3h72'] + queues['gpu-debug'] + queues['gpu-n2h24'] + queues['gpu-n1h72'] + queues['n4h24'] + queues['n3h72']
	queues['zarate'] = queues['phi-debug'] + queues['phi-n2h72'] + queues['phi-n3h24']
	queues['total'] = (get_global_data(log))/3600

	# Plots data in dictionaries
	# Users
	plt.figure(1)
	plt.title('Service Units per User')
	plt.bar(range(len(users)), users.values(), align='center')
	plt.xticks(range(len(users)), list(users.keys()))
	plt.savefig('user_rank.pdf')

	# Global and queues
	plt.figure(2)
	plt.title('Service Units per queue')
	plt.bar(range(len([0,1,2])), [queues['total'], queues['cadejos'], queues['zarate']], align='center')
	plt.xticks(range(len([0,1,2])), ['total','cadejos','zarate'])
	plt.savefig('queue_usage.pdf')

	# Uncomment to display plots.
	plt.show()

if __name__ == "__main__":
	main()
