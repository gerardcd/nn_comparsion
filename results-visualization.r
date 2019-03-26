require('rgl')

setwd('/home/gerard/Documents/ADM/paper1/results')

keras_results = read.csv('keras_results.csv', header=TRUE)
neural_results = read.csv('neural_results.csv', header=TRUE)

# Time
plot(keras_results[, c(1,4)])
plot(keras_results[, c(2,4)])
plot3d(keras_results[, c(1,2,4)], type='s', col='blue')

plot(neural_results[, c(1,4)])
plot(neural_results[, c(2,4)])
plot3d(neural_results[, c(1,2,4)], type='s', col='blue')

# Accuracy
plot(keras_results[, c(1,3)])
plot(keras_results[, c(2,3)])
plot3d(keras_results[, c(1,2,3)], type='s', col='blue')

plot(neural_results[, c(1,3)])
plot(neural_results[, c(2,3)])
plot3d(neural_results[, c(1,2,3)], type='s', col='blue')
