create or refresh streaming table cs_bronze_book
(
    CONSTRAINT valid_booking_id EXPECT (booking_id IS NOT NULL),
    CONSTRAINT valid_stay_dates EXPECT (check_in_date <= check_out_date),
    CONSTRAINT valid_guests EXPECT (guests > 0),
    CONSTRAINT valid_room_rate EXPECT (room_rate >= 0)
)
AS
SELECT
    *,
    _metadata.file_name AS source_file,
    current_timestamp() AS loaded_at

FROM STREAM read_files(
    '/Volumes/hotel_booking/default/hotel_catlog',
    format => 'csv',
    header => true
);
