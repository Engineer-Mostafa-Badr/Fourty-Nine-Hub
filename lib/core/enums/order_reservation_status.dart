enum OrderReservationStatus {
  Upcoming(1),
  Cancelled(2),
  Completed(3);

  final int value;
  const OrderReservationStatus(this.value);
}
