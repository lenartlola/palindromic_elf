with open('palindromic', 'rb') as f:
   data = f.read()

swap_data = bytearray(data)
swap_data.reverse()

with open('palindromic_reversed', 'wb') as f:
   f.write(swap_data)