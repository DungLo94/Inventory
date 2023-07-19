#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np


# In[77]:


a=pd.read_csv("BegInvFINAL12312016.csv")
a[a['Brand']==58].shape


# In[127]:


a.head()


# In[3]:


b=pd.read_csv("EndInvFINAL12312016.csv")
b.head()


# In[121]:


b['onHand'].sum()


# In[4]:


c=pd.read_csv("InvoicePurchases12312016.csv")
c.head()


# In[125]:


c['PONumber'].nunique()


# In[46]:


d=pd.read_csv("PurchasesFINAL12312016.csv")
d.head()


# In[119]:


d['Quantity'].sum()


# In[113]:


df=pd.DataFrame(d['InventoryId'])
df[['Store', 'City', 'Brand']]=df['InventoryId'].str.split('_',expand=True)
df['City'].unique()


# In[116]:


values_not_subset = [element for element in b['City'].unique() if element not in df['City'].unique()]
values_not_subset


# In[6]:


e=pd.read_csv("SalesFINAL12312016.csv")
e.head()


# In[120]:


e['SalesQuantity'].sum()


# In[7]:


f=pd.read_csv("2017PurchasePricesDec.csv")
f.head()


# In[92]:


f['Brand'].nunique()


# In[93]:


f.shape


# In[126]:


f[f['Brand']==1004]


# In[ ]:




