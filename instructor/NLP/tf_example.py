import tensorflow as tf
import numpy as np

const = tf.constant(5.0, name="const")
#y = tf.Variable(2.0, name='y')
y = tf.placeholder(tf.float32, [None,1], name='y')
z = tf.Variable(1.0, name='z')

# operations
l = tf.add(y, z, name='l')
m = tf.add(z, const, name='m')
x = tf.multiply(l, m, name='x')

# variable initialization
init_op = tf.global_variables_initializer()

# start Tensorflow session
with tf.Session() as sess:
    sess.run(init_op)
    #x_out = sess.run(x)
    x_out = sess.run(x, feed_dict={y: np.arange(0,10)[:, np.newaxis]})
    print("Variable x is {}".format(x_out))
