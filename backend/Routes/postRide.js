const express = require("express");
const router = express.Router();
const Ride = require("../Model/postRide.js");

// POST a new ride
router.post("/", async (req, res) => {
    console.log("I Am Working");
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

    // ----------------------------
    // Validate all required fields
    // ----------------------------
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

    // ----------------------------
    // Create the ride
    // ----------------------------
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

module.exports = router;
