import { ZodError } from 'zod';

export const validate = (schema, source = 'query') => (req, res, next) => {
  try {
    req.validated = schema.parse(req[source]);
    next();
  } catch (error) {
    if (error instanceof ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: error.issues });
    }
    return next(error);
  }
};
