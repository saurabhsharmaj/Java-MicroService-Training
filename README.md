git clone -b feature/docker  https://github.com/saurabhsharmaj/Java-MicroService-Training.git 

docker-compose up --build -d

postman

POST=  http://localhost:8082/api/v1/users
   
BODY > JSON

{
  "firstName": "docker",
  "lastName": "user",
  "email": "docker@example.com",
  "createdBy": "admin",
  "updatedBy": "admin"
}

grafana

localhost:3000

IMPORT Greafana Dashboard = 19004
