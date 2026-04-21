# Workflow Ideal para Desarrollar un Proyecto
> Síntesis de Best Practices + Dupla Workflow + Sistema de Trabajo  
> **Última actualización:** 2026-04-13

---

## Visión General

```
Discovery → Planning → Design → Development → Validation
     ↓          ↓         ↓          ↓            ↓
  IDEA.md  ROADMAP.md  PoC/Wireframes  Sprints   Lessons
```

Cada fase cierra con un checkpoint de decisión antes de avanzar.

---

## FASE 1: DISCOVERY (Problema Real)
**Objetivo:** Validar que vale la pena construir esto.  
**Duración:** 2–5 días  
**Dueño:** Tú + usuario real (si es posible)

### Qué hacer
| Tarea | Método | Output |
|---|---|---|
| Define el problema en 1 frase | "X no puede hacer Y porque Z" | Problema claro |
| Identifica quién lo sufre (usuario real) | Entrevistas, observación | Usuario definido |
| ¿Existe ya una solución? | Investigación de mercado | Gaps vs soluciones existentes |
| Elige el criterio de éxito | Métrica medible | MOEs (Measures of Effectiveness) |
| Analiza viabilidad técnica | Spike rápido si hay riesgo | Make/Buy/Reuse decisión |

### Output
📄 **`docs/IDEA.md`** (1 página)
```markdown
# IDEA: [nombre del proyecto]

## Problema
[1 frase clara]

## Usuario
[Quién, qué necesita, por qué ahora]

## Soluciones existentes
[Qué hay, por qué no funciona]

## Criterio de éxito (MOEs)
- [ ] [Métrica 1]
- [ ] [Métrica 2]
- [ ] [Métrica 3]

## Viabilidad
- Técnica: ✅ / ⚠️ / ❌ (Spike: ...)
- Negocio: ✅ / ⚠️ / ❌ (Inversión estimada)

## Go/No-Go
[ ] Proceder a Planning
```

### Checkpoint
**Pregunta:** ¿Construirías esto hoy si tuvieras 3 meses? Si la respuesta es NO → vuelve a IDEA.

---

## FASE 2: PLANNING (Roadmap Concreto)
**Objetivo:** De "qué construir" a "cómo lo dividimos".  
**Duración:** 3–5 días  
**Dueño:** Tú + Claude

### Qué hacer
| Tarea | Método | Output |
|---|---|---|
| Desglosa en features mínimos | MoSCoW (Must/Should/Could) | Alcance MVP |
| Define requisitos funcionales | "Shall" statements cuantificables | PRD light |
| Elige stack tecnológico | Make/Buy/Reuse analysis | Tech stack final |
| Documenta *por qué* cada decisión | Decisiones no obvias | DECISIONS.md |
| Crea roadmap visual | Timeline + milestones | ROADMAP.md |

### Outputs
📄 **`docs/ROADMAP.md`**
```markdown
# Roadmap: [Proyecto]

## MVP (Sprint 1–3)
- [ ] Feature A (x días)
- [ ] Feature B (x días)

## Fase 2 (Sprint 4–6)
- [ ] Feature C

## Fase 3 (Future)
- [ ] Feature D

## Stack
- Frontend: Next.js + React + Tailwind
- Backend: Supabase + Node.js
- Deploy: Vercel + VPS
- Tools: Git + NotebookLM + Claude Code
```

📄 **`docs/DECISIONS.md`** (decisiones no obvias)
```markdown
# Decisiones Técnicas Clave

## [Decisión 1]: Por qué Supabase y no Firebase
- ✅ Control de datos (EU-hosted)
- ✅ RLS nativo para multi-tenant
- ❌ Menos herramientas pre-built que Firebase
- **Decisión:** Supabase

## [Decisión 2]: Por qué Next.js App Router
- ✅ Server Components
- ✅ Mejor SEO por defecto
- **Decisión:** App Router
```

### Checkpoint
**Pregunta:** ¿Puedo explicar a alguien por qué cada decisión técnica? Si hay 1+ que no sabes, vuelve a PLANNING.

---

## FASE 3: DESIGN (Solución Visual + Técnica)
**Objetivo:** Planear antes de codificar.  
**Duración:** 3–7 días  
**Dueño:** Tú + feedback de usuario si es UX-heavy

### Qué hacer
| Tarea | Método | Output |
|---|---|---|
| Dibuja el flujo del usuario | Figma wireframes o papel | User flow claro |
| Modela los datos | Diagrama ER o tabla simple | Schema inicial |
| Diseña la arquitectura técnica | Diagrama de módulos | System architecture |
| Crea un prototipo interactivo | Figma clickable o HTML simple | PoC funcional |
| Prueba resonancia con usuario | Demostración del PoC | Feedback temprano |

### Output
📁 **`/design`** folder con:
- `user_flows.md` (secuencia paso a paso)
- `data_model.md` (ERD o tabla de datos)
- `system_architecture.md` (módulos, APIs)
- `figma_link.txt` (enlace a prototipo)

### Checkpoint
**Pregunta:** ¿Un usuario real entiende el flujo? ¿Te dice "sí, así querría que fuera"? Si no → itera el PoC.

---

## FASE 4: DEVELOPMENT (Sprints Iterativos)
**Objetivo:** Construir + validar en paralelo.  
**Duración:** Sprints de 1–4 semanas  
**Dueño:** Tú (Claude es tu pair programmer)

### Qué hacer

#### Inicio de sprint
- [ ] Leer `ROADMAP.md` → features del sprint
- [ ] Abrir branch: `git checkout -b work/[feature]`
- [ ] Comando: `/new-session "agregar feature X"`

#### Durante sprint
| Práctica | Por qué | Cómo |
|---|---|---|
| **Test Driven** | Evita bugs después | Red → Green → Refactor |
| **Commits pequeños** | Revertir es barato | 1 commit = 1 concepto |
| **PRs enfocados** | Más fácil de revisar | 200–400 líneas máximo |
| **CI/CD automático** | Errores tempranos | GitHub Actions o Vercel |
| **Formative Evaluation** | Descubrir barreras ahora | Testear con usuario real weekly |

#### Validación mid-sprint
Cada semana (o cada 2 features):
- [ ] Integración con base de datos ✅
- [ ] Testing de componente crítico ✅
- [ ] Demo interna o con usuario ✅
- [ ] Documentar barriers en `PROBLEMS.md` si las hay ✅

#### Fin de sprint
- [ ] `npm run build` (Next.js)
- [ ] `git merge work/[feature] → main`
- [ ] `git push origin main` (Vercel auto-deploy)
- [ ] `/progress` (actualiza PROJECT_STATE.md)

### Output
```
main branch
├── ✅ Feature A (Sprint 1)
├── ✅ Feature B (Sprint 2)
├── 🚧 Feature C (Sprint 3 — en progress)
```

### Checkpoint
**Pregunta:** ¿Está versionado en GitHub? ¿Pasó el build? ¿Un usuario lo probó? Si NO a cualquiera → no mergea a main.

---

## FASE 5: VALIDATION (Confirmación)
**Objetivo:** Validar que se construyó lo correcto de la forma correcta.  
**Duración:** 3–7 días  
**Dueño:** Tú + usuarios reales

### Qué hacer
| Pregunta | Método | Decisión |
|---|---|---|
| ¿Se cumplieron los MOEs? | Analytics + lógica de negocio | Éxito sí/no |
| ¿Los usuarios lo usan como esperamos? | Testing, feedback, behavioral data | Cambios necesarios |
| ¿Hay bugs críticos? | QA exhaustiva | Hotfix o v1.1 |
| ¿Qué aprendimos? | Retrospectiva blame-free | Lecciones para próximo proyecto |

### Outputs

📊 **Validation Report** (actualizar PROJECT_STATE.md)
```markdown
## Resultados
- MOE 1: ✅ / ⚠️ / ❌ (valor: x%)
- MOE 2: ✅ / ⚠️ / ❌ (valor: x%)
- Bugs críticos: [lista]

## Lecciones
- ✅ Lo que funcionó: [acelerador]
- ❌ Lo que bloqueó: [barrera]
- 💡 Para próximo proyecto: [insight]
```

📝 **`docs/PROBLEMS.md`** actualizado
```markdown
# Problemas Resueltos

## [Título del error]
**Contexto:** Qué pasó  
**Causa:** Por qué  
**Solución:** Cómo lo arreglamos  
**Fecha:** 2026-04-13
```

### Checkpoint
**Pregunta:** ¿Puedo hacer deploy a producción? ¿Confío en la calidad? Si NO → vuelve a Development o cierra bugs en PROBLEMS.md.

---

## FLUJO INTEGRADO CON TU SISTEMA

### Comandos clave en cada fase

| Fase | Comando | Qué hace |
|---|---|---|
| Discovery | (manual) | Creas IDEA.md |
| Planning | `/new-project` | Genera estructura + CLAUDE.md |
| Design | `/new-session "disenar X"` | Claude lee y propone arquitectura |
| Development | `/new-session "agregar feature"` | Claude inicia rama + plan |
| Validation | `/progress` | Actualiza PROJECT_STATE.md con lecciones |

### Git workflow (siempre)

```bash
# Iniciar sesión
/new-session "agregar feature X"

# Trabajar
git checkout -b work/feature-x
[código]
git commit -m "feat(módulo): descripción"

# Validar
npm run build
git push origin work/feature-x
[PR review]

# Mergear
git checkout main
git merge work/feature-x
git push origin main

# Cierre
/progress
```

---

## MEJORES PRÁCTICAS (Por fase)

### Discovery
- ✅ Habla con usuarios reales — no supongas
- ✅ Busca si ya existe una solución — evita Work in Progress innecesario
- ✅ Define métricas antes de construir — no inventes después
- ❌ No comiences a codificar sin IDEA.md validado

### Planning
- ✅ Documenta el por qué de decisiones — no solo el qué
- ✅ Haz Make/Buy/Reuse analysis — ¿hay librería?
- ✅ Define alcance mínimo — MVP sin feature creep
- ❌ No diseñes para el caso hipotético — construye para el usuario real

### Design
- ✅ Prototipa en baja fidelidad primero (papel, wireframes)
- ✅ Valida con usuario antes de codificar
- ✅ Documenta el modelo de datos antes de tocar código
- ❌ No comiences el sprint sin arquitectura clara

### Development
- ✅ Commits pequeños — 1 commit = 1 concepto lógico
- ✅ Test temprano — TDD si es posible
- ✅ Testea con usuarios reales mid-sprint
- ✅ Documenta en PROBLEMS.md cada error — reutiliza la solución
- ❌ No mergeas a main sin build verde
- ❌ No cambies el stack a mitad de sprint

### Validation
- ✅ Mide contra los MOEs originales
- ✅ Captura lecciones — alimentan el próximo Discovery
- ✅ Retrospectiva blame-free — qué aceleró, qué bloqueó
- ❌ No cierres el proyecto sin actualizar PROBLEMS.md
- ❌ No declares "éxito" si los usuarios no lo usan

---

## TIMELINE TÍPICO (Proyecto pequeño)

| Fase | Duración | Hitos |
|---|---|---|
| Discovery | 2–5 días | IDEA.md validado |
| Planning | 3–5 días | ROADMAP.md + DECISIONS.md listos |
| Design | 3–7 días | PoC probado con usuario |
| Development | 4–12 semanas | Sprints 1–4, features en main |
| Validation | 3–7 días | Métricas validadas, PROBLEMS.md cerrado |
| **Total** | **7–13 semanas** | **Producto lanzado** |

---

## CHECKLIST RÁPIDA

### Antes de comenzar
- [ ] ¿Existe IDEA.md validado?
- [ ] ¿Hay usuario real que lo necesita?
- [ ] ¿Vale la pena 2–3 meses de trabajo?

### Antes de Planning
- [ ] ¿Probaste el PoC con usuario?
- [ ] ¿Documentaste por qué cada decisión técnica?

### Antes de Development
- [ ] ¿Está el repo en GitHub?
- [ ] ¿Hay ROADMAP.md clara?
- [ ] ¿Está configurado el CI/CD?

### Antes de merge a main
- [ ] ¿Pasó `npm run build`?
- [ ] ¿Está documentado en PROBLEMS.md si hay errores?
- [ ] ¿Lo probó alguien además de ti?

### Antes de Validation
- [ ] ¿Está todo en main?
- [ ] ¿Está deployado?
- [ ] ¿Tienes datos de usuarios reales?

### Antes de cerrar proyecto
- [ ] ¿Actualicé PROJECT_STATE.md con lecciones?
- [ ] ¿Capturé qué funcionó / qué no?
- [ ] ¿Documenté decisiones en DECISIONS.md?

---

## RESUMEN EN 1 PÁGINA

```
🎯 Discovery: ¿Vale la pena? (IDEA.md)
    ↓
📋 Planning: ¿Cómo lo partimos? (ROADMAP.md + DECISIONS.md)
    ↓
🎨 Design: ¿Cómo se ve / funciona? (PoC validado)
    ↓
💻 Development: Construir + testear con usuario real (Sprints)
    ↓
✅ Validation: ¿Cumplimos los MOEs? (Lecciones → próximo proyecto)
```

**Regla de oro:** Cada fase cierra con un checkpoint de decisión. Si falla = vuelve atrás. No avances con dudas.

---

**Última revisión:** 2026-04-13  
**Próxima revisión:** Después de 2 proyectos con este workflow
