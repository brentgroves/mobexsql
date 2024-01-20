select * from users
--delete from users where id = 5

curl 'http://localhost:3030/messages/' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6ImFjY2VzcyJ9.eyJpYXQiOjE2OTQ1NTUxNDAsImV4cCI6MTY5NDY0MTU0MCwiYXVkIjoiaHR0cHM6Ly95b3VyZG9tYWluLmNvbSIsInN1YiI6IjEiLCJqdGkiOiIxN2U3NzdlOS1mNTNmLTQ3ZmQtODVlNy00Y2M1NjgzZDYzNzUifQ.a02j9NK27Ok3XVW_KtjxZKmYfIRFdhY4NN40Wvj3reo' \
  --data-binary '{ "text": "Hello from the console" }'