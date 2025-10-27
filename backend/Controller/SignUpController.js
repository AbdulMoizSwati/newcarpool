const User = require("../Model/LoginModel.js");

const handleSignin = async (req, res) => {
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
  // 3️⃣ Prepare user object
  // -----------------------------
  const newUserData = {
    name,
    email,
    age,
    gender,
    contact,
    idCard,
    password,
    role,
    carDetails: role.toLowerCase() === "driver" ? carDetails : undefined,
  };

  // -----------------------------
  // 4️⃣ Save to MongoDB
  // -----------------------------
  try {
    const newUser = new User(newUserData);
    await newUser.save();
    return res.status(201).json({ message: "User registered successfully!" });
  } catch (err) {
    console.error("Error saving user:", err);
    return res.status(500).json({ error: "Server error" });
  }
};

module.exports = handleSignin;
