#%%
import numpy as np

#%%
matrix_one = np.array((range(1, 8*8+1)))
matrix_one

# %%
matrix_2 = np.reshape(matrix_one, (8, 8))
# %%
matrix_2[:3, -5:]
# %%
n = 7

mat_zero = np.zeros((n, n), dtype=int)
mat_zero

# %%
x, y = mat_zero.shape

x_pos = x//2
y_pos = y//2

print(x_pos, y_pos)

# %%
for i in range(x):
    for j in range(y):
        if i == x_pos or j == y_pos:
            mat_zero[i, j] += 1
        

# %%
mat_zero

# %%
vv