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
      min: 1,
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
    rideStatus: {
      type: String,
      enum: ['active', 'completed', 'cancelled'],
      default: 'active',
    },
    passengers: [
      {
        passengerId: String,
        passengerName: String,
        seatsBooked: Number,
      },
    ],
  },
  { timestamps: true } // automatically adds createdAt and updatedAt
);

postRide = mongoose.model('Ride', rideSchema);

module.exports = postRide;
