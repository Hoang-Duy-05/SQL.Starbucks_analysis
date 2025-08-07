
-- 1. Phân tích nhân khẩu học (Demographic Analysis)
-- Mục tiêu: Phân tích xem độ tuổi có ảnh hưởng đến giá trị đơn hàng trung bình hay không.
SELECT 
    DISTINCT([user_id]),
    [age],
    AVG([order_value]) AS avg_value
FROM [dbo].[starbucks_digital_marketing_data]
GROUP BY [user_id], [age]
ORDER BY avg_value DESC;


-- 2. Sở thích sản phẩm theo giới tính (Product Preference by Gender)
-- Mục tiêu: So sánh sự khác biệt về sở thích sản phẩm giữa nam và nữ.
SELECT 
    [gender],
    [product_preference],
    COUNT(*) AS SL
FROM [dbo].[starbucks_digital_marketing_data]
GROUP BY GROUPING SETS (
    ([product_preference], [gender]), 
    ([product_preference]), 
    ([gender])
);


-- 3. Mức độ sử dụng app theo khu vực (App Usage by Region)
-- Mục tiêu: Kiểm tra tần suất sử dụng app có khác biệt theo từng khu vực địa lý hay không.
WITH frequency AS (
    SELECT 
        [user_id],
        [location],
        CASE 
            WHEN [app_usage_frequency] = 'Monthly' THEN 30
            WHEN [app_usage_frequency] = 'Weekly' THEN 7
            WHEN [app_usage_frequency] = 'Daily' THEN 1
            ELSE 40 
        END AS app_usage_frequency
    FROM [dbo].[starbucks_digital_marketing_data]
)
SELECT 
    DISTINCT([location]),
    AVG(app_usage_frequency) AS avg_app_usage_frequency
FROM frequency
GROUP BY [location];


-- 4. Giá trị đơn hàng & mạng xã hội (Order Value & Social Media Engagement)
-- Mục tiêu: Kiểm tra mối tương quan giữa giá trị đơn hàng và mức độ tương tác mạng xã hội.
SELECT
    CORR([order_value], [social_media_engagement]) AS corr_v_s
FROM [dbo].[starbucks_digital_marketing_data];


-- 5. Sản phẩm phổ biến trong chiến dịch mùa vụ (Seasonal Campaign Products)
-- Mục tiêu: Xác định khách hàng tham gia chiến dịch mùa vụ thường chọn sản phẩm nào.
SELECT
    COUNT(CASE WHEN [product_preference] = 'Cappuccino' THEN 1 END) AS T_Cappuccino,
    COUNT(CASE WHEN [product_preference] = 'Iced Coffee' THEN 1 END) AS T_Iced_Coffee,
    COUNT(CASE WHEN [product_preference] = 'Latte' THEN 1 END) AS T_Latte,
    COUNT(CASE WHEN [product_preference] = 'Espresso' THEN 1 END) AS T_Espresso,
    COUNT(CASE WHEN [product_preference] = 'Americano' THEN 1 END) AS T_Americano,
    COUNT(CASE WHEN [product_preference] = 'Local Special' THEN 1 END) AS T_Local_Special
FROM starbucks_digital_marketing_data
WHERE [seasonal_campaign_engagement] <> 0;
