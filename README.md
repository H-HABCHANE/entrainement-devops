# entrainement-devops

Une API FastAPI de carte de restaurant avec un pipeline CI/CD GitHub Actions qui publie l'image sur Docker Hub.

## Ce que fait le pipeline

Sur une Pull Request, le pipeline vérifie la qualité et bloque la fusion si une erreur est détectée. Sur la branche `main`, il publie l'image. Les 3 jobs s'enchaînent :

1. **qualite** : installe les dépendances, lance le linter (Ruff) et les tests (Pytest).
2. **image** : construit l'image Docker, démarre le conteneur et vérifie qu'il devient `healthy`, que l'API répond et que l'utilisateur n'est pas root. Une image qui ne démarre pas n'est jamais publiée.
3. **publier** (uniquement sur `main`) : publie l'image sur Docker Hub avec deux tags (le SHA du commit et `latest`).

## Lancer le projet en local

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-dev.txt
ruff check .
pytest
```

## Ce que ça démontre

- Une image au `CMD` cassé bloque la fusion de la Pull Request.
- Docker Hub ne reçoit rien dans ce cas : `publier` est ignoré.
- Un ruleset protège `main` : Pull Request obligatoire et jobs `qualite` et `image` requis.
