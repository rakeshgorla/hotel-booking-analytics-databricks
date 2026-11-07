
CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_clean (
  CONSTRAINT valid_stay_dates EXPECT (check_out_date > check_in_date) ON VIOLATION DROP ROW,
  CONSTRAINT valid_room_rate  EXPECT (room_rate >= 0)                 ON VIOLATION DROP ROW
) AS
SELECT DISTINCT
  booking_id, guest_id, check_in_date, check_out_date,
  COALESCE(nights, DATEDIFF(check_out_date, check_in_date))      AS nights,
  COALESCE(INITCAP(TRIM(city)), 'Unknown')                        AS city,
  INITCAP(TRIM(room_type))                                        AS room_type,
  COALESCE(total_amount,
           DATEDIFF(check_out_date, check_in_date) * room_rate)   AS total_amount,
  booking_status,
  booking_date,
  hotel_name,
  region,
  COALESCE(INITCAP(TRIM(booking_channel)), 'Unknown')            AS booking_channel,
  guests,
  room_rate,
  discount_amount,
  COALESCE(INITCAP(TRIM(meal_plan)), 'Unknown')                 AS meal_plan,
  payment_method,
  payment_status,
  guest_rating
FROM cs_bronze_book;
 
CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_rejected AS
SELECT *,
  CASE WHEN check_out_date <= check_in_date THEN 'Check-out is not after check-in'
       ELSE 'Room rate is negative' END AS reject_reason
FROM cs_bronze_book
WHERE check_out_date <= check_in_date OR room_rate < 0;

