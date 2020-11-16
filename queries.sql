## Assumes that the exercise_id column is in the order the exercises were
## completed in; i.e., exercises are numbered 1,2,3,etc. and the date of
## exercise N+1 will never be earlier than the date for exercise N.  Also
## assumes that the Exercises table will not have user_ids that don't exist in
## the Users table.


## QUERY 1: How many users completed an exercise in their first month per monthly cohort?

SELECT created_month AS cohort, 100*AVG(created_month<=>first_exercise) AS percent_in_first_month FROM (
  SELECT Users.user_id, date_format(Users.created_at, "%Y-%m") AS created_month, first_exercise FROM Users LEFT JOIN (
    SELECT Exercises.user_id, date_format(min(Exercises.exercise_completion_date), "%Y-%m") AS first_exercise FROM Exercises
    GROUP BY user_id
  ) AS FirstExer ON Users.user_id=FirstExer.user_id
) AS firsts GROUP BY created_month;



## QUERY 2: How many users completed a given amount of exercises?

SELECT num_exercises, COUNT(*) AS count_frequency FROM (
  SELECT Users.user_id, COALESCE(number_of_exercises,0) AS num_exercises FROM Users LEFT JOIN (
    SELECT user_id, COUNT(*) as number_of_exercises FROM Exercises GROUP BY user_id
  ) AS ExerCount ON Users.user_id=ExerCount.user_id
) AS ExerFreq GROUP BY num_exercises ORDER BY num_exercises;


## QUERY 3: Which organizations have the most severe patient population?
SELECT Providers.provider_id, COALESCE(avg_score,0) AS provider_avg_score FROM Providers LEFT JOIN (
  SELECT provider_id, AVG(score) as avg_score FROM Phq9 GROUP BY provider_id
) AS AvgScores ON Providers.provider_id=AvgScores.provider_id
ORDER BY provider_avg_score DESC
LIMIT 5;
