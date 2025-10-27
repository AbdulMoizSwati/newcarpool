const express = require("express");
const bcrypt = require("bcrypt"); // ✅ Import bcrypt
const User = require("../Model/LoginModel.js"); // Adjust path if needed

const signup = express.Router();
console.log("SignupRouter IS Hit");

// POST /api/users/signup
signup.post("/", async (req, res) => {
  console.log("📨 Data received from Flutter:", req.body);

  const {
    name,
    email,
    age,
    gender,
    contact,
    idCard,
    password,
    role,
    carDetails
  } = req.body;

  // -----------------------------
  // 1️⃣ Basic validation for all users
  // -----------------------------
  if (!name || !email || !age || !gender || !contact || !idCard || !password || !role) {
    return res.status(400).json({ error: "All fields are required!" });
  }

  // -----------------------------
  // 2️⃣ Driver-specific validation
  // -----------------------------
  if (role.toLowerCase() === "driver") {
    if (!carDetails) {
      return res.status(400).json({ error: "Car details are required for drivers!" });
    }

    const { carType, carNumber, licenseNumber } = carDetails;

    if (!carType || !carNumber || !licenseNumber) {
      return res.status(400).json({ error: "All car details fields are required!" });
    }
  }

  // -----------------------------
  // 3️⃣ Check if email already exists
  // -----------------------------
  try {
    const existingUser = await User.findOne({ email: email.toLowerCase() });
    if (existingUser) {
      return res.status(400).json({ error: "Email is already in use!" });
    }
  } catch (err) {
    console.error("Error checking existing email:", err);
    return res.status(500).json({ error: "Server error" });
  }

  // -----------------------------
  // 4️⃣ Hash the password
  // -----------------------------
  let hashedPassword;
  try {
    hashedPassword = await bcrypt.hash(password, 3); // 3 = salt rounds
  } catch (err) {
    console.error("Error hashing password:", err);
    return res.status(500).json({ error: "Server error" });
  }

  // -----------------------------
  // 5️⃣ Prepare user object
  // -----------------------------
  const newUserData = {
    name,
    email: email.toLowerCase(),
    age,
    gender,
    contact,
    idCard,
    password: hashedPassword, // ✅ store hashed password
    role,
    carDetails: role.toLowerCase() === "driver" ? carDetails : undefined,
  };

  // -----------------------------
  // 6️⃣ Save to MongoDB
  // -----------------------------
  try {
    const newUser = new User(newUserData);
    await newUser.save();
    return res.status(201).json({ message: "User registered successfully!" });
  } catch (err) {
    console.error("Error saving user:", err);
    return res.status(500).json({ error: "Server error" });
  }
});

module.exports = signup;
