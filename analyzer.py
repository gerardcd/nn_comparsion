import time
import subprocess
import re

KERAS = 'keras'
NN = 'neuralnetwork'

commands = {}
commands[KERAS] = 'python kerasModel.py'
commands[NN] = 'Rscript nnetModel.r'

# Extract accuracy value from the scripts results
def extraxtTestAccuracy(output):
	regex = re.compile("Test accuracy: [0-9]\.[0-9]+")
	search = regex.search(output)

	tst_accuracy_str = search.group()
	tst_accuracy = float(tst_accuracy_str[15:])

	return tst_accuracy

# Run a model and return its test accuracy and running time
def runInstance(model, hidden_neurons, epochs):
	command = commands[model]

	start = time.time()
	output = subprocess.Popen(command + ' ' + str(hidden_neurons) + ' ' + str(epochs), shell=True, stdout=subprocess.PIPE).stdout.read()
	end = time.time()

	elapsed_time = end - start
	tst_accuracy = extraxtTestAccuracy(output)

	return (tst_accuracy, elapsed_time)

# TIME AND ACCURACY EXPERIMENTS

twos = [2**x for x in range(6)]

# Empty the results files
open('results/keras_results.csv', 'w').close()
open('results/neural_results.csv', 'w').close()

with open('results/keras_results.csv', 'a') as keras_results, open('results/neural_results.csv', 'a') as neural_results:
	keras_results.write('hidden_neurons, epochs, accuracy, time\n')
	neural_results.write('hidden_neurons, epochs, accuracy, time\n')

	for hidden_neurons in twos:
		for epochs in twos:

			print('Running: hidden_neurons: ' + str(hidden_neurons) + ', epochs: ' + str(epochs))
			
			(tst_accuracy, elapsed_time) = runInstance(KERAS, hidden_neurons, epochs)
			keras_results.write(str(hidden_neurons) + ', ' + str(epochs) + ', ' + str(tst_accuracy) + ', ' + str(elapsed_time) + '\n')

			(tst_accuracy, elapsed_time) = runInstance(NN, hidden_neurons, epochs)
			neural_results.write(str(hidden_neurons) + ', ' + str(epochs) + ', ' + str(tst_accuracy) + ', ' + str(elapsed_time) + '\n')


# KERAS LONG RUN EXPERIMENTS

fours = [4**x for x in range(7)]

# Empty the results file
open('results/keras_long_run_results.csv', 'w').close()

with open('results/keras_long_run_results.csv', 'a') as keras_long_run_results:
	keras_long_run_results.write('hidden_neurons, epochs, accuracy, time\n')

	for hidden_neurons in fours:
		epochs = 32

		print('Running: hidden_neurons: ' + str(hidden_neurons) + ', epochs: ' + str(epochs))

		(tst_accuracy, elapsed_time) = runInstance(KERAS, hidden_neurons, epochs)
		keras_long_run_results.write(str(hidden_neurons) + ', ' + str(epochs) + ', ' + str(tst_accuracy) + ', ' + str(elapsed_time) + '\n')

