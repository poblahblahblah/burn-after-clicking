# README

## Running Locally

### Build with Docker

```
docker-compose up --build
```

### Running Without Building

```
docker-compose up
```

### Creating a Secret

Browse to http://localhost:3000/secrets. There should be a button to Create a new Secret.

### Verifying the Secret is Encrypted in the DB

```
docker-compose run web bin/rails dbconsole
```

Once in the Postgres Console, run the following command:

```
select * from secrets;
```

You should get something similar returned:

```
burn_development=# select * from secrets;
                  id                  | title |      encrypted_body      |    encrypted_body_iv     |                           password                           |     expiration      |         created_at         |         updated_at
--------------------------------------+-------+--------------------------+--------------------------+--------------------------------------------------------------+---------------------+----------------------------+----------------------------
 5e0c3ea6-2fff-48fb-90a0-b933fd7d3b65 | test  | 7P+6MI3EBkhNcjW7TRtwFQ==+| Ryd8Qfeo4qi+N8icJjCUug==+| $2a$10$PBLGdy4D7ubQSw29cdWwQ.8nnrWcBG5JPD12XxCHHS7cIjRclLEYG | 2019-02-20 15:47:00 | 2019-02-20 15:47:07.369064 | 2019-02-20 15:47:07.369064
```

## TODO
  * Background job to delete entries after the expiration has passed
  * Make sure of the optional password
