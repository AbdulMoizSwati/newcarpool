const express = require("express");
const Connect = require("./connection/connection.js");
const signup = require("./Routes/SignUpRoute.js");
const bcrypt = require("bcrypt");
const User = require("./Model/LoginModel.js");
const loginRouter = require("./Routes/login.js");
const postRide = require("./Routes/postRide.js");




const app = express();
const port = 8001;

Connect();

// Middleware to parse JSON
app.use(express.json());

// ✅ Log every incoming request
app.use((req, res, next) => {
  console.log(`➡️  ${req.method} request received on ${req.url}`);
  next();
});

// -----------------------------
// Signup Route
// -----------------------------
app.use("/api/users/signup",signup);
app.use("/api/users/login",loginRouter);
app.use("/api/users/postRide",postRide);


  
 

app.listen(port, "0.0.0.0", () => {
  console.log(`🚀 Server is listening on http://192.168.1.100:${port}`);
});
