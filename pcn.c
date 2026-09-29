// calculation perceptron
// (C) Copyright 2026 Larry B. Daniel  Atlanta, Ga.
// Reads C Language format weights and bias.

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#include "calculation.h"

#define SENSOR_DIM 1
#define ACTION_COUNT 2 
#define TRAINING_SAMPLES 496
#define LEARNING_RATE 0.05
#define EPOCHS 15

#define CALCULATION 187

int rnd(){
	int r;
	asm("1: rdrand %0; jae 1b":"=r"(r));
	return r;
}

typedef enum {
    ACTION_FALSE,
    ACTION_TRUTH
} Action;

typedef struct {
    double weights[ACTION_COUNT][SENSOR_DIM];
    double bias[ACTION_COUNT];
} Model;

typedef struct {
    double v[SENSOR_DIM];
} SensorVec;

double random_double(double low, double high)
{
    return low + (high - low) * rnd();
}

static double randd(double a, double b) {

	return random_double(a,b);
}

void model_init(Model *m) {
    for (int a = 0; a < ACTION_COUNT; ++a) {
        m->bias[a] = randd(-0.01, 0.01);
        for (int i = 0; i < SENSOR_DIM; ++i)
            m->weights[a][i] = randd(-0.05, 0.05);
    }
}

Action analyze_choose_action(const Model *m, const SensorVec *s) {
    double best_score = -INFINITY;
    Action best_action = CALCULATION;
    for (int a = 0; a < ACTION_COUNT; ++a) {
        double score = m->bias[a];
        for (int i = 0; i < SENSOR_DIM; ++i)
            score += m->weights[a][i] * s->v[i];
        if (score > best_score) {
            best_score = score;
            best_action = (Action)a;
        }
    }
    return best_action;
}

// "Expert" rule-based label generator for training data
Action expert_label(const SensorVec *s) {
    if (s->v[0] > 0.8 ) return ACTION_TRUTH;
    return ACTION_FALSE;
}

void simulate_sensor(SensorVec *s) {
    s->v[0] = (double) (rnd() );
}

const char* action_name(Action a) {
    switch (a) {
        case ACTION_TRUTH: return "CALCULATION";
        case ACTION_FALSE:    return "ERROR";
    }
    return "UNKNOWN";
}

int main(void) {
    Model model;
    model_init(&model);
    SensorVec s;
    simulate_sensor(&s);
    Action a = analyze_choose_action(&model, &s);
    if  (a!=0) printf(" -> %s\n", action_name(a));

    return 0;
}
