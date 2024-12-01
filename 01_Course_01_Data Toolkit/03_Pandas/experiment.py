#%%
import pandas as pd

# %%
df = pd.read_csv('https://media-doselect.s3.amazonaws.com/generic/NMgEjwkAEGGQZBoNYGr9Ld7w0/rating.csv')
df.sort_values(['Office', 'Department'], axis=0, inplace=True)
df.set_index(['Office', 'Department'], inplace=True)
# %%
print(df.head(20))

# %%
