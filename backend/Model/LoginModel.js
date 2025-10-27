const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    // 🧍 Basic Info
    name: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    age: { type: Number, required: true, min: 16 },
    gender: { type: String, enum: ["Male", "Female"], required: true },
    contact: { type: String, required: true, trim: true },
    idCard: { type: String, required: true, trim: true },
    password: { type: String, required: true },

    // 🧩 Profile InfoSSSS
    profileImagePath: { type: String, default: "" },
    role: { type: String, enum: ["Passenger", "Driver"], required: true },

    // 🚗 Only for Drivers
    carDetails: {
      carType: { type: String },
      carNumber: { type: String },
      licenseNumber: { type: String },
    },

    // 🕒 Metadata
    createdAt: { type: Date, default: Date.now },
  },
  { timestamps: true } // Adds createdAt & updatedAt automatically
);

const Users = mongoose.model("User", userSchema);

module.exports = Users;
