// models/Ride.js
const mongoose = require('mongoose');

const rideSchema = new mongoose.Schema(
  {
    driverId: {
      type: String,
      required: true,
    },
    driverName: {
      type: String,
      required: true,
    },
    pickupLocation: {
      type: String,
      required: true,
    },
    dropoffLocation: {
      type: String,
      required: true,
    },
    availableSeats: {
      type: Number,
      required: true,
      min: 0,
    },
    totalSeats: {
      type: Number,
      required: true,
      min: 1,
    },
    departureDate: {
      type: Date,
      required: true,
    },
    pricePerSeat: {
      type: Number,
      required: true,
      min: 0,
    },
    vehicleType: {
      type: String,
      required: true,
    },
    vehiclePlate: {
      type: String,
      required: true,
    },
    licenseNumber: {
      type: String,
      required: true,
    },

    // Ride lifecycle
    rideStatus: {
      type: String,
      enum: ['active', 'completed', 'cancelled'],
      default: 'active',
    },
   
  },
  { timestamps: true }
);

const Ride = mongoose.model('Ride', rideSchema);

module.exports = Ride;
