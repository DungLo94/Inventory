#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np


# In[2]:


a=pd.read_csv("BegInvFINAL12312016.csv")
a.head()


# In[3]:


a.shape


# In[4]:


a.info()


# In[5]:


a['InventoryId'].nunique()


# In[6]:


a['Store'].nunique()


# In[7]:


a['City'].nunique()


# In[10]:


a['Brand'].nunique()


# In[11]:


a['startDate'].nunique()


# In[8]:


b=pd.read_csv("EndInvFINAL12312016.csv")
b.head()


# In[20]:


b.shape


# In[21]:


b.info()


# In[25]:


b['InventoryId'].nunique()


# In[16]:


b['Store'].nunique()


# In[17]:


b['City'].nunique()


# In[18]:


b['Brand'].nunique()


# In[19]:


b['endDate'].nunique()


# In[9]:


f=pd.read_csv("2017PurchasePricesDec.csv")
f.head()


# In[24]:


f.shape


# In[26]:


f.info()


# In[27]:


f['Brand'].nunique()


# In[28]:


f['Classification'].nunique()


# In[32]:


f['Size'].nunique()


# In[33]:


f['Volume'].nunique()


# In[29]:


f['VendorNumber'].nunique()


# In[31]:


f['VendorName'].nunique()


# In[10]:


c=pd.read_csv("InvoicePurchases12312016.csv")
c.head()


# In[13]:


c.shape


# In[14]:


c.info()


# In[15]:


c['VendorNumber'].nunique()


# In[16]:


c['VendorName'].nunique()


# In[18]:


c['PONumber'].nunique()


# In[17]:


c['InvoiceDate'].min(),c['InvoiceDate'].max()


# In[19]:


c['PODate'].min(),c['PODate'].max()


# In[20]:


c['PayDate'].min(),c['PayDate'].max()


# In[2]:


d=pd.read_csv("PurchasesFINAL12312016.csv")
d.head()


# In[3]:


d.shape


# In[5]:


d.info()


# In[6]:


d['VendorNumber'].nunique()


# In[7]:


d['VendorName'].nunique()


# In[9]:


d['InventoryId'].nunique()


# In[10]:


d['Store'].nunique()


# In[11]:


d['Brand'].nunique()


# In[13]:


d['PONumber'].nunique()


# In[14]:


d['ReceivingDate'].min(),d['ReceivingDate'].max()


# In[15]:


e=pd.read_csv("SalesFINAL12312016.csv")
e.head()


# In[16]:


e.shape


# In[17]:


e.info()


# In[19]:


e['InventoryId'].nunique()


# In[20]:


e['Store'].nunique()


# In[21]:


e['Brand'].nunique()


# In[22]:


e['SalesDate'].min(),e['SalesDate'].max()


# In[ ]:




