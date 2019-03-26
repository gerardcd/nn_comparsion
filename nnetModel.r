args = commandArgs(trailingOnly=TRUE)

if (length(args) < 2){
  stop('Usage: Rscript nnetModel.r <n_hidden_neurons> <n_epochs>')
}

require('mltools')
require('neuralnet')
require('ANN2')

setwd('/home/gerard/Documents/ADM/paper1')

hidden_neurons = as.numeric(args[1])
batch_size = 128
num_classes = 7
epochs = as.numeric(args[2])
hidden_activation = 'relu'
output_activation = 'softmax'

optimizer = 'rmsprop'
learning_rate = 0.001 # Default keras value for the RMSprop optimizer's learning rate
decay = 0.9 # Default keras value for the RMSprop optimizer's decay (rho parameter)

loss = 'log' # Keras categorical cross_entropy

shuttle.trn <- read.table(file = "shuttle.trn", header=FALSE, sep=" ")
shuttle.tst <- read.table(file = "shuttle.tst", header=FALSE, sep=" ")

model <- neuralnetwork(
  shuttle.trn[, 1:9], shuttle.trn$V10, 
  hidden=c(hidden_neurons),
  activ.functions=c(hidden_activation),
  optim.type=optimizer,
  loss=loss,
  learn.rates=learning_rate,
  regression=FALSE, 
  n.epochs=epochs, 
  batch.size=batch_size,
  rmsprop.decay=decay,
  verbose=TRUE
)

# Test accuracy
predictions.tst <- predict(model, newdata=shuttle.tst[, 1:9])
correct <- predictions.tst$predictions == shuttle.tst$V10
paste(
  'Test accuracy:',
  length(correct[correct==TRUE]) / length(correct),
  sep=' '
)