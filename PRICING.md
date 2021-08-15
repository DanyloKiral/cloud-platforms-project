
# x1

### Storage account

Assume we have a 30GB archive per month. 
To calculate one year pricing for storage - 30*12 ~ 400GB. As data is arriving evenly, we’ll have 200 GB occupied per year, on average.

Assume we have it arriving as every-minute batch - that’s 
365*24*60 ~ 600 000 batches. 
Per batch we perform single write and single read operations.

![image](https://user-images.githubusercontent.com/15198798/129491788-ad1cc903-033c-4463-8278-0c6fa7a871a0.png)

![image](https://user-images.githubusercontent.com/15198798/129491810-56c474f4-df34-491d-9faa-20d79c6bda4c.png)

![image](https://user-images.githubusercontent.com/15198798/129491818-3839217d-c646-4717-887f-48523f54e939.png)

![image](https://user-images.githubusercontent.com/15198798/129491844-d0cc0470-8973-4fa5-af3d-8c57f7db1e52.png)

### Event hub

Assume we have 50 million messages monthly, on average.
Each message is 0.65KB, on average.

Each minute we’ll have ~100 messages, that’s 65KB.
So we’ll need 1 throughput unit. 

![image](https://user-images.githubusercontent.com/15198798/129491863-d532da10-18da-4da6-b372-4603af79e9fc.png)

### SQL server

Each message left a 1 record in 2 tables, + ~10 records in 1 table.
Each record is 2 + 20 + 10 + 8 = 40 bytes in the case of the first 2 tables, and 2 + 20 + 250 + 8 = 280 bytes.
So, it is 40*2 + 10*280 = 2880 bytes ~ 3 KB.

At the end of the year we’ll have ~150 GB.

![image](https://user-images.githubusercontent.com/15198798/129491879-3542e567-1355-4750-bf67-2acad8513d8f.png)

### App service

![image](https://user-images.githubusercontent.com/15198798/129491888-498b92a1-64a1-4141-a2c3-9c863b11fd46.png)

### Functions

4 functions.
1 - executes once per minute (minute batch) ~ 45 000
3 others - once per record. ~ 3 * 50m = 150m

Sum = 150 045 000 executions.

![image](https://user-images.githubusercontent.com/15198798/129491923-b3f2848d-33c9-4a80-a685-424f025fd617.png)

## Total

![image](https://user-images.githubusercontent.com/15198798/129491910-c6b8e6ef-4667-49ef-91e7-aedbbf02b8d4.png)

# x10

![image](https://user-images.githubusercontent.com/15198798/129492085-886525ac-003d-472a-ad19-f4f94f743458.png)
![image](https://user-images.githubusercontent.com/15198798/129492208-a1e623c2-575a-4662-92b8-eb04af6729c0.png)

# x100

![image](https://user-images.githubusercontent.com/15198798/129492255-36047284-cab8-42b1-9843-4c55cc85ba80.png)

![image](https://user-images.githubusercontent.com/15198798/129492263-063e872e-970d-414f-a5cf-1bebeaf3e361.png)

# x1000

![image](https://user-images.githubusercontent.com/15198798/129492349-98ae5d0e-4dee-42ef-8aa5-7262b01d2021.png)

![image](https://user-images.githubusercontent.com/15198798/129492357-53b836fc-98a1-4854-9dda-91dd05075846.png)

