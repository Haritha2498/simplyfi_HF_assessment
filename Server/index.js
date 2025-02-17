const  express= require('express');
const app = express();
const routes= require("./Routes/routes.js");


app.use(express.json());
const PORT = 3000;

app.use('/', routes);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});



