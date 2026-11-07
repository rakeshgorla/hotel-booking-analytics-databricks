CREATE OR REFRESH MATERIALIZED VIEW gold_monthly_bookings AS
SELECT DATE_TRUNC('MONTH', check_in_date)                          AS stay_month,
       COUNT(*)                                                    AS bookings,
       SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END)  AS cancelled_bookings,
       SUM(CASE WHEN booking_status = 'Completed' THEN nights ELSE 0 END) AS room_nights,
       SUM(CASE WHEN booking_status = 'Completed'
                THEN total_amount - discount_amount ELSE 0 END)     AS net_revenue
FROM silver_bookings_clean
GROUP BY DATE_TRUNC('MONTH', check_in_date);

CREATE OR REFRESH MATERIALIZED VIEW gold_hotel_summary AS
SELECT region, city, hotel_name,
       COUNT(*)                                                    AS bookings,
       SUM(CASE WHEN booking_status = 'Completed' THEN nights ELSE 0 END) AS room_nights,
       SUM(CASE WHEN booking_status = 'Completed'
                THEN total_amount - discount_amount ELSE 0 END)     AS net_revenue,
       SUM(CASE WHEN booking_status = 'Completed'
                THEN total_amount - discount_amount ELSE 0 END)
         / NULLIF(SUM(CASE WHEN booking_status = 'Completed' THEN nights ELSE 0 END), 0) AS avg_daily_rate
FROM silver_bookings_clean
GROUP BY region, city, hotel_name;

CREATE OR REFRESH MATERIALIZED VIEW gold_room_type_summary AS
SELECT room_type,
       COUNT(*)                                                    AS bookings,
       SUM(CASE WHEN booking_status = 'Completed' THEN nights ELSE 0 END) AS room_nights,
       SUM(CASE WHEN booking_status = 'Completed'
                THEN total_amount - discount_amount ELSE 0 END)     AS net_revenue,
       AVG(guest_rating)                                           AS avg_rating
FROM silver_bookings_clean
GROUP BY room_type;

CREATE OR REFRESH MATERIALIZED VIEW gold_channel_summary AS
SELECT booking_channel,
       COUNT(*)                                                    AS bookings,
       SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings,
       SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0
         / COUNT(*)                                                AS cancellation_rate_pct,
       SUM(CASE WHEN booking_status = 'Completed'
                THEN total_amount - discount_amount ELSE 0 END)     AS net_revenue
FROM silver_bookings_clean
GROUP BY booking_channel;

CREATE OR REFRESH MATERIALIZED VIEW gold_data_quality AS
SELECT COUNT(*)                                                   AS bronze_rows,
       COUNT(*) - COUNT(DISTINCT booking_id)                      AS duplicate_rows,
       SUM(CASE WHEN check_out_date <= check_in_date THEN 1 ELSE 0 END) AS invalid_date_rows,
       SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END)               AS missing_city_rows,
       SUM(CASE WHEN room_rate < 0 THEN 1 ELSE 0 END)             AS negative_rate_rows,
       SUM(CASE WHEN booking_channel IS NULL THEN 1 ELSE 0 END)    AS missing_channel_rows,
       SUM(CASE WHEN total_amount IS NULL THEN 1 ELSE 0 END)       AS missing_amount_rows,
       SUM(CASE WHEN nights IS NULL THEN 1 ELSE 0 END)             AS missing_nights_rows,
       (SELECT COUNT(*) FROM silver_bookings_clean)                AS clean_rows,
       (SELECT COUNT(*) FROM silver_bookings_rejected)             AS rejected_rows
FROM cs_bronze_book;

