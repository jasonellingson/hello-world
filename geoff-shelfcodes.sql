-- test to add a new line
-- shelf codes for BK-264
-- THIS ONE NEEDS SOME WORK FOR PART 3 AND THE DATES. 

SELECT
    om.SHELF_CODE,
    shelf.intransit,
    shelf2.avgcreatedon
FROM ORD_MASTER om WITH (NOLOCK)

JOIN
    (
        SELECT om2.SHELF_CODE, COUNT(ORD_ITEM_ID) as 'intransit'
        FROM ORD_MASTER om2 WITH (NOLOCK) 
            JOIN ORD_ITEM oi2 WITH (NOLOCK) ON om2.ORD_ID = oi2.ORD_ID
        WHERE
            oi2.ACTIVE_FLAG = 1 AND 
            oi2.[STATUS] = 'ITT' AND
            om2.ORD_SHIPMENT_TYPE = 'ps' AND
            om2.ORD_CATEGORY IS NULL AND
            om2.ORD_SOURCE = 'p' AND
            om2.MARKETPLACE IS NULL
        GROUP BY
            om2.SHELF_CODE
    )
    AS shelf ON om.SHELF_CODE = shelf.SHELF_CODE

LEFT JOIN
    (
        SELECT om3.SHELF_CODE, DATEDIFF(day, om3.CREATED_ON, SYSDATETIME()) as 'avgcreatedon'
        FROM ORD_MASTER om3 WITH (NOLOCK)
            JOIN ORD_ITEM oi3 WITH (NOLOCK) ON om3.ORD_ID = oi3.ORD_ID
        WHERE
            oi3.ACTIVE_FLAG = 1 AND 
            oi3.[STATUS] = 'IWE' AND
            om3.ORD_SHIPMENT_TYPE = 'ps' AND
            om3.ORD_CATEGORY IS NULL AND
            om3.ORD_SOURCE = 'p' AND
            om3.MARKETPLACE IS NULL
    )
    AS shelf2 ON om.SHELF_CODE = shelf2.SHELF_CODE

GROUP BY
	om.SHELF_CODE,
	shelf.intransit,
	shelf2.avgcreatedon

ORDER BY
	om.SHELF_CODE


