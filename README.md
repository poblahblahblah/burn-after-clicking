# Burn After Clicking

Step sending secrets through email.

## What is this?

A tool that you can use to more securely relay information to friends, family, partners, clients, coworkers, and strangers. All secrets are encrypted before being saved to the DB, and you can optionally set a password to use for encrypting that must also be used to unlock the secret. Once the link has been viewed it dissapears forever.

[Check out the demo](https://burn-after-clicking.herokuapp.com/).

If you are thinking about using this, please deploy it yourself so you can be more in control over your secrets.

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

Browse to http://localhost:3000. There should be a button to Create a new Secret.

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
                  id                  | title |                           password                           |                            encrypted_body                            |                       encrypted_body_salt                        |         expiration         |         created_at         |         updated_at
--------------------------------------+-------+--------------------------------------------------------------+----------------------------------------------------------------------+------------------------------------------------------------------+----------------------------+----------------------------+----------------------------
 6da6c231-d3cf-4387-a3e0-b2c2b3615e73 | test  | $2a$10$9C.qLdU6nR2YyUFj9WUetO3wEj35WhNxLpXTJIVqdfgr/rNfBY5H2 | jziUARrV9B6c0rui71zjrvZr--g90F8A+BmkFVeLQD--sPNUpTDSm0hy9BM5ThXhJQ== | 83a72aeed9ad6ee66b895ea30fc3a557838bd580374f8c3508e95c9aec47ac32 | 2019-05-02 08:25:16.631233 | 2019-05-01 20:25:16.767563 | 2019-05-01 20:25:16.767563
 27857ee7-d452-44cb-9cfc-fd69f3f701d1 | test  | $2a$10$qikVctiH0hUXYJgkV1sLVe1pLFGlNO6W0t.uDMFCyiMiM5vDSQ6aG | drxa3uICqoZu2dh/X48=--0NllsY+BzZJ7MwZs--ayJF7KPD9w6w0xLSBIjaLQ==     | f0c644c568353cddd0a1c04d3baa3e236ad0a4d43ddbc65a544b5388a379ef81 | 2019-05-01 21:52:04.1354   | 2019-05-01 20:52:04.269374 | 2019-05-01 20:52:04.269374
```

## Healthcheck and Metrics endpoints

Define your healthcheck and metric endpoint passwords as environment variables. Generate the basic auth headers:

```
# password is foobar, but the colon is required since we don't have a username.
Base64.strict_encode64(":foobar")
```

Test with curl:

```
curl -D - -H 'Authorization:Basic OmZvb2Jhcg==' localhost:3000/metrics
```

## TODO
  * K8s templates
