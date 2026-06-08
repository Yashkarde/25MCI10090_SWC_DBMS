WITH valid_tasks AS (
    SELECT DISTINCT
        task_id,
        task_name,
        start_time,
        end_time
    FROM task_schedule
    WHERE start_time IS NOT NULL
      AND end_time IS NOT NULL
),

events AS (
    SELECT
        start_time AS event_time,
        1 AS change
    FROM valid_tasks

    UNION ALL

    SELECT
        end_time AS event_time,
        -1 AS change
    FROM valid_tasks
),

cpu_usage AS (
    SELECT
        event_time,
        SUM(change) OVER (
            ORDER BY event_time, change
        ) AS active_cpus
    FROM events
)

SELECT
    MAX(active_cpus) AS min_cpus_required
FROM cpu_usage;