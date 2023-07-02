CREATE VIEW person_full_info_view AS
SELECT person.id,
       name,
       email,
       phone_number,
       password,
       marital_status_key,
       sex_key,
       birthday,
       city_id,
       height
FROM person
         INNER JOIN person_credentials pc on person.id = pc.person_id
         INNER JOIN person_public_info ppi on person.id = ppi.person_id;

CREATE VIEW solved_objective_view AS
SELECT person_id,
       objective_id,
       programming_language_key,
       solving,
       title,
       description,
       template
FROM solved_objective
         INNER JOIN objective o on o.id = solved_objective.objective_id;
