# Inventory Control Managment

Welcome to my AbapGit repository.

In this repository, I would like to show my ABAP skills.

## Installation

1. Clone repository or dowload zip (when your server is offline),
2. Download file data/products_data.csv to your device,
3. Go to se37 transaction,
4. Execute ARCHIVFILE_CLIENT_TO_SERVER function module,
5. Add PATH to products_data.csv location in your device,
6. Add TARGETPATH /usr/sap/NPL/D00/work/products_data.csv,
7. Execute zkk_load_products program to insert data to zkk_products table. 

## Important programs

zkk_products: CRUD (create/read/update/delete data) in zkk_products.
