const express = require("express");
const postRide = express.Router();
const Ride = require("../Model/postRide.js");

console.log("Ride routes are working");

// ----------------------------
// POST a new ride
// ----------------------------
postRide.post("/", async (req, res) => {
  console.log("Post ride endpoint hit");
  try {
    const {
      driverId,
      driverName,
      pickupLocation,
      dropoffLocation,
      availableSeats,
      totalSeats,
      departureDate,
      pricePerSeat,
      vehicleType,
      vehiclePlate,
      licenseNumber,
    } = req.body;

    // Validate required fields
    if (!driverId) return res.status(400).json({ error: "Driver ID is required" });
    if (!driverName) return res.status(400).json({ error: "Driver name is required" });
    if (!pickupLocation) return res.status(400).json({ error: "Pickup location is required" });
    if (!dropoffLocation) return res.status(400).json({ error: "Dropoff location is required" });
    if (!availableSeats && availableSeats !== 0) return res.status(400).json({ error: "Available seats are required" });
    if (!totalSeats && totalSeats !== 0) return res.status(400).json({ error: "Total seats are required" });
    if (!departureDate) return res.status(400).json({ error: "Departure date is required" });
    if (!pricePerSeat && pricePerSeat !== 0) return res.status(400).json({ error: "Price per seat is required" });
    if (!vehicleType) return res.status(400).json({ error: "Vehicle type is required" });
    if (!vehiclePlate) return res.status(400).json({ error: "Vehicle plate is required" });
    if (!licenseNumber) return res.status(400).json({ error: "License number is required" });

    const ride = new Ride({
      driverId,
      driverName,
      pickupLocation,
      dropoffLocation,
      availableSeats,
      totalSeats,
      departureDate,
      pricePerSeat,
      vehicleType,
      vehiclePlate,
      licenseNumber,
      rideStatus: "active",
      createdAt: new Date().toISOString(),
    });

    await ride.save();

    res.status(201).json({ message: "Ride posted successfully", ride });
  } catch (err) {
    console.error("Error posting ride:", err);
    res.status(500).json({ error: "Server error while posting ride" });
  }
});

// ----------------------------
// GET all rides for a specific driver
// ----------------------------
postRide.get("/:driverId", async (req, res) => {
  try {
    const { driverId } = req.params;

    if (!driverId) return res.status(400).json({ error: "Driver ID is required" });

    const rides = await Ride.find({ driverId }).sort({ departureDate: -1 }); // latest first

    res.status(200).json(rides);
  } catch (err) {
    console.error("Error fetching rides:", err);
    res.status(500).json({ error: "Server error while fetching rides" });
  }
});

// ----------------------------
// DELETE a ride by ID (optional for driver)
// ----------------------------
postRide.delete("/:rideId", async (req, res) => {
  try {
    const { rideId } = req.params;

    const deletedRide = await Ride.findByIdAndDelete(rideId);

    if (!deletedRide) {
      return res.status(404).json({ error: "Ride not found" });
    }

    res.status(200).json({ message: "Ride deleted successfully" });
  } catch (err) {
    console.error("Error deleting ride:", err);
    res.status(500).json({ error: "Server error while deleting ride" });
  }
});

module.exports = postRide;
