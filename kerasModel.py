from __future__ import print_function

import sys

if len(sys.argv) < 3:
    print('Usage: kerasModel.py <n_hidden_neurons> <n_epochs>')
    exit(1)

from pandas import DataFrame
from keras.layers import Dense
from keras.models import Sequential

hidden_neurons = int(sys.argv[1])
batch_size = 128
num_classes = 7
epochs = int(sys.argv[2])
hidden_activation = 'relu'
output_activation = 'softmax'
optimizer = 'RMSprop'
loss = 'categorical_crossentropy'

# one hot encoding
def encode(value):
    value = int(value) - 1
    return [
        1 if value == i else 0
        for i in range(num_classes)
    ]

def dataSetFromFile(fileName):
    xData = []
    yData = []
    with open(fileName) as file:
        for row in file:
            values = row.split()

            xData.append(values[:-1])
            
            yData.append(
                encode(values[-1])
            )

    return (DataFrame(xData), DataFrame(yData))

(xTrain, yTrain) = dataSetFromFile('shuttle.trn')
(xTest, yTest) = dataSetFromFile('shuttle.tst')

model = Sequential()
model.add(Dense(hidden_neurons, activation=hidden_activation, input_shape=(9,)))
model.add(Dense(num_classes, activation=output_activation))

model.summary()

model.compile(loss=loss,
              optimizer=optimizer,
              metrics=['accuracy'])

history = model.fit(xTrain, yTrain,
                    batch_size=batch_size,
                    epochs=epochs,
                    verbose=1,
                    validation_data=(xTest, yTest))

score = model.evaluate(xTest, yTest, verbose=1)
print('Test loss:', score[0])
print('Test accuracy:', score[1])