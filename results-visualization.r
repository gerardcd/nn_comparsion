require('rgl')

setwd('/home/gerard/Documents/ADM/paper1/results')

keras_results = read.csv('keras_results.csv', header=TRUE)
neural_results = read.csv('neural_results.csv', header=TRUE)

twos <- c(1,2,4,8,16,32)
# TIME
#######
# Keras training time seems not to be affected by the number of hidden neurons
# This might happen because the numbers we are using here are to small for Tensor Flow.

for (i in twos){
  col <- c(i,i,i,i,i,i)
  plot(keras_results[keras_results$epochs == i, c(1,4)], col=c(i), ylim=c(0,13), xlim=c(0,32), type='o')
  par(new=TRUE)
}
legend(22,5, col=c(1,2,4,8,16,32), fill=c(32,16,8,4,2,1), legend=paste(c(32,16,8,4,2,1), ' epochs'))
par(new=FALSE)

plot3d(keras_results[, c(1,2,4)], type='s', col='blue')

# On the other hand, neuralnetwork training time do is affected by number of hidden neurons.

for (i in twos){
  col <- c(i,i,i,i,i,i)
  plot(neural_results[neural_results$epochs == i, c(1,4)], col=c(i), ylim=c(0,40), xlim=c(0,32), type='o')
  par(new=TRUE)
}
legend(22, 12, col=c(1,2,4,8,16,32), fill=c(32,16,8,4,2,1), legend=paste(c(32,16,8,4,2,1), ' epochs'))
par(new=FALSE)

plot3d(neural_results[, c(1,2,4)], type='s', col='blue')

# Keras time presents a strange spike at a very small number of neurons.
plot(keras_results[keras_results$epochs == 32, c(1,4)], col='yellow', type='l')

# But it is almost constant compared to that one of neuralnetwork.
# Neuralnetwork is linnear at a ratio aroud 1 second / neuron
plot(keras_results[keras_results$epochs == 32, c(1,4)], col='yellow', type='o', ylim=c(10, 35))
par(new=TRUE)
plot(neural_results[neural_results$epochs == 32, c(1,4)], col='green', type='o', ylim=c(10, 35))
par(new=FALSE)
legend(27, 20, legend=c('Keras', 'NN'), fill=c('yellow', 'green'))

# ACCURACY

# Keras accuracy is unnstable even for 32 epochs. Again, this might be due to the small size of the numbers used here
for (i in twos){
  col <- c(i,i,i,i,i,i)
  plot(keras_results[neural_results$epochs == i, c(1,3)], col=c(i), ylim=c(0,1), xlim=c(0,32), type='o')
  par(new=TRUE)
}
legend(22, 0.3, col=c(1,2,4,8,16,32), fill=c(32,16,8,4,2,1), legend=paste(c(32,16,8,4,2,1), ' epochs'))
par(new=FALSE)

plot3d(keras_results[, c(1,2,3)], type='s', col='blue')

# neuralnetwork accuracy is more stable and quickly converges to numbers very close to 1
#plot(neural_results[, c(1,3)])
#plot(neural_results[, c(2,3)])
for (i in twos){
  col <- c(i,i,i,i,i,i)
  plot(neural_results[neural_results$epochs == i, c(1,3)], col=c(i), ylim=c(0.5,1), xlim=c(0,32), type='o')
  par(new=TRUE)
}
legend(22, 0.65, col=c(1,2,4,8,16,32), fill=c(32,16,8,4,2,1), legend=paste(c(32,16,8,4,2,1), ' epochs'))
par(new=FALSE)

plot3d(neural_results[, c(1,2,3)], type='s', col='blue')

# Fixing epochs to 32:
# neuralnetwork seems more appropiated to work with shuttle dataset (complexity of the problem / size):
# Although its trainning time is slower than the Keras one, it's still reasonable.
# Also, it's more stable for this particular problem, and it achieves the maximum accuracy (actually more than keras).
plot(keras_results[keras_results$epochs == 32, c(1,3)], col='yellow', type='l', ylim=c(0, 1))
par(new=TRUE)
plot(neural_results[neural_results$epochs == 32, c(1,3)], col='green', type='l', ylim=c(0, 1))
legend(25, 0.2, legend=c('Keras', 'NN'), fill=c('yellow', 'green'))

# KERAS LONG RUN

keras_long_run_results = read.csv('keras_long_run_results.csv', header=TRUE)

# Time

# Keras time is also linnear, but a much smaller ratio than the one of neuralnetwork
plot(neural_results[neural_results$epochs == 32, c(1,4)], col='green', type='l', ylim=c(5, 45), xlim=c(0, 4000))
par(new=TRUE)
plot(keras_long_run_results[, c(1, 4)], type='l', col='yellow', ylim=c(5, 45), xlim=c(0, 4000))

# Accuracy
# The accuracy has an eventual drop to 0 for 16 hidden neurons. It seems to reach a maximum at 256 hidden neurons,
# which is still preserved at 1024 neurons, and then drops down. It's reasonable that more neurons need more epochs to train.
plot(keras_long_run_results[, c(1, 3)], type='l', col='green')
