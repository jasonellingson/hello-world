-- request from Geoff Sutherland - ticket BK-264

SELECT
    v.NAME as 'Store',
    slips.sourcing,
    slips2.printed,
    slips3.intransit
FROM VENDOR v WITH (NOLOCK)

JOIN
    (SELECT v.VENDOR_ID, COUNT(ORD_ITEM_ID) as 'sourcing'
    FROM ORD_MASTER om WITH (NOLOCK)
        JOIN ORD_ITEM oi WITH (NOLOCK) ON om.ORD_ID = oi.ORD_ID
        JOIN VENDOR v WITH (NOLOCK) ON oi.VENDOR_ID = v.VENDOR_ID
    WHERE
        oi.ACTIVE_FLAG = 1 AND
        oi.[STATUS] = 'SCG' AND
        om.ORD_SHIPMENT_TYPE = 'ps' AND
        om.ORD_CATEGORY IS NULL AND
        om.ORD_SOURCE = 'p' AND
        om.MARKETPLACE IS NULL
    GROUP BY  
        v.VENDOR_ID
    )
    AS slips ON v.VENDOR_ID = slips.VENDOR_ID

LEFT JOIN
    (SELECT v2.VENDOR_ID, COUNT(ORD_ITEM_ID) as 'printed'
    FROM ORD_MASTER om2 WITH (NOLOCK)
        JOIN ORD_ITEM oi2 WITH (NOLOCK) ON om2.ORD_ID = oi2.ORD_ID
        JOIN VENDOR v2 WITH (NOLOCK) ON oi2.VENDOR_ID = v2.VENDOR_ID
    WHERE
        oi2.ACTIVE_FLAG = 1 AND
        oi2.[STATUS] = 'RSP' AND
        om2.ORD_SHIPMENT_TYPE = 'ps' AND
        om2.ORD_CATEGORY IS NULL AND
        om2.ORD_SOURCE = 'p' AND
        om2.MARKETPLACE IS NULL
    GROUP BY  
        v2.VENDOR_ID
    )
    AS slips2 ON v.VENDOR_ID = slips2.VENDOR_ID

LEFT JOIN
    (SELECT v3.VENDOR_ID, COUNT(ORD_ITEM_ID) as 'intransit'
    FROM ORD_MASTER om3 WITH (NOLOCK)
        JOIN ORD_ITEM oi3 WITH (NOLOCK) ON om3.ORD_ID = oi3.ORD_ID
        JOIN VENDOR v3 WITH (NOLOCK) ON oi3.VENDOR_ID = v3.VENDOR_ID
    WHERE
        oi3.ACTIVE_FLAG = 1 AND
        oi3.[STATUS] = 'ITT' AND
        om3.ORD_SHIPMENT_TYPE = 'ps' AND
        om3.ORD_CATEGORY IS NULL AND
        om3.ORD_SOURCE = 'p' AND
        om3.MARKETPLACE IS NULL
    GROUP BY  
        v3.VENDOR_ID
    )
    AS slips3 ON v.VENDOR_ID = slips3.VENDOR_ID

GROUP BY
    v.NAME,
    slips.sourcing,
    slips2.printed,
    slips3.intransit




    
