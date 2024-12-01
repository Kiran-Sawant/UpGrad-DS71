import numpy as np
import pandas as pd

# The file is stored at the following path:
# 'https://media-doselect.s3.amazonaws.com/generic/A08MajL8qN4rq72EpVJbAP1Rw/marks_1.csv'
# Provide your answer below
column = ['S.No.', 'Name', 'Subject', 'Maximun Marks', 'Marks Obtained', 'Percentage']

df = pd.read_csv("https://media-doselect.s3.amazonaws.com/generic/A08MajL8qN4rq72EpVJbAP1Rw/marks_1.csv", delimiter='|', header=None)
df.columns = column

df.set_index(['S.No.'], inplace=True)

print(df)