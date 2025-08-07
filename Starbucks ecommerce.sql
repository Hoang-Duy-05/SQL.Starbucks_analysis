-- Mục tiêu: tìm những sản phẩm tìm năng để nhập về kinh doanh --

-- 1/ Sản phẩm có tổng số lượng bán và doanh thu cao nhất từng thương hiệu
WITH rank_Total_revenue AS (
    SELECT 
        Brand,
        [Tên sản phẩm],
        [Tổng doanh số],
        [Tổng lượt bán],
        [Giá bán],
        DENSE_RANK() OVER (PARTITION BY Brand ORDER BY [Tổng doanh số] DESC) AS rank_total
    FROM dhfood
)

SELECT *
FROM rank_Total_revenue
WHERE rank_total <= 3;


-- 2/ Sản phẩm có số lượng bán và doanh thu cao nhất từng thương hiệu trong 365 ngày gần nhất
WITH rank_365_last AS (
    SELECT 
        Brand,
        [Tên sản phẩm],
        [Doanh số 365 ngày gần nhất],
        [Sản phẩm đã bán trong khoảng 365 ngày gần nhất],
        [Giá bán],
        DENSE_RANK() OVER (PARTITION BY Brand ORDER BY [Doanh số 365 ngày gần nhất] DESC) AS rank_365
    FROM dhfood
)

SELECT *
FROM rank_365_last
WHERE rank_365 <= 3;

-- Nhận xét:
-- Trong 365 ngày qua, các sản phẩm có mức giá từ 25.000 đến 35.000 VND ghi nhận số lượng bán cao. 
-- Tuy nhiên, xu hướng tiêu dùng đang cho thấy sự sụt giảm trong việc lựa chọn các sản phẩm cao cấp có giá từ 100.000 đến 500.000 VND, 
-- được phản ánh qua doanh thu giảm của một số thương hiệu sở hữu các sản phẩm giá cao.


-- 3/ So sánh top doanh thu tổng và 365 ngày gần nhất theo từng thương hiệu
WITH rank_Total_revenue AS (
    SELECT 
        Brand,
        [Tên sản phẩm],
        [Tổng doanh số],
        [Tổng lượt bán],
        [Giá bán],
        DENSE_RANK() OVER (PARTITION BY Brand ORDER BY [Tổng doanh số] DESC) AS rank_total
    FROM dhfood
),
T_R AS (
    SELECT *
    FROM rank_Total_revenue
    WHERE rank_total <= 3
),
rank_365_last AS (
    SELECT 
        Brand,
        [Tên sản phẩm],
        [Doanh số 365 ngày gần nhất],
        [Sản phẩm đã bán trong khoảng 365 ngày gần nhất],
        [Giá bán],
        DENSE_RANK() OVER (PARTITION BY Brand ORDER BY [Doanh số 365 ngày gần nhất] DESC) AS rank_365
    FROM dhfood
),
T_R_365 AS (
    SELECT *
    FROM rank_365_last
    WHERE rank_365 <= 3
)

SELECT 
    T_R.Brand,
    T_R.[Tên sản phẩm] AS Tên_sản_phẩm_total,
    T_R_365.[Tên sản phẩm] AS Tên_sản_phẩm_365,
    T_R.[Giá bán]
FROM T_R
FULL JOIN T_R_365
    ON T_R.rank_total = T_R_365.rank_365 AND T_R.Brand = T_R_365.Brand
ORDER BY Brand, [Giá bán] DESC;


-- 4/ Các sản phẩm lọt vào top 5 doanh thu cả trong tổng số và trong 365 ngày gần nhất
WITH rank_Total_revenue AS (
    SELECT 
        Brand,
        [Tên sản phẩm],
        [Tổng doanh số],
        [Tổng lượt bán],
        [Giá bán],
        DENSE_RANK() OVER (PARTITION BY Brand ORDER BY [Tổng doanh số] DESC) AS rank_total
    FROM dhfood
),
T_R AS (
    SELECT *
    FROM rank_Total_revenue
    WHERE rank_total <= 5
),
rank_365_last AS (
    SELECT 
        Brand,
        [Tên sản phẩm],
        [Doanh số 365 ngày gần nhất],
        [Sản phẩm đã bán trong khoảng 365 ngày gần nhất],
        [Giá bán],
        DENSE_RANK() OVER (PARTITION BY Brand ORDER BY [Doanh số 365 ngày gần nhất] DESC) AS rank_365
    FROM dhfood
),
T_R_365 AS (
    SELECT *
    FROM rank_365_last
    WHERE rank_365 <= 5
)

SELECT 
    T_R.Brand,
    T_R.[Tên sản phẩm] AS Tên_sản_phẩm_total,
    T_R_365.[Tên sản phẩm] AS Tên_sản_phẩm_365,
    T_R.[Giá bán]
FROM T_R
FULL JOIN T_R_365
    ON T_R.rank_total = T_R_365.rank_365 AND T_R.Brand = T_R_365.Brand
WHERE T_R.[Tên sản phẩm] = T_R_365.[Tên sản phẩm]
ORDER BY Brand, [Giá bán] DESC;

-- Nhận xét:
-- Qua phân tích và so sánh, khoảng 7 sản phẩm liên tục duy trì vị trí trong top doanh thu,
-- cho thấy đây là những sản phẩm tiêu dùng phổ biến và có sức hút mạnh mẽ. 
-- Đề xuất xem xét kỹ lưỡng các sản phẩm này để lựa chọn nhập về kinh doanh.
