using Movement.Controllers;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace Movement
{
    public class GasConsumer : MonoBehaviour
    {
        [SerializeField] private FloatVariable _gas;
        [SerializeField] private float _consumptionPerSecond;
        [SerializeField] private InputController _engine;

        private void Update()
        {
            if (_engine.IsRunning)
            {
                float consumption = Time.deltaTime * _consumptionPerSecond;
                _gas.Subtract(consumption);
            }
        }
    }
}