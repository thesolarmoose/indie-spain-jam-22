using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace DepthLogic
{
    public class MetersUpdater : MonoBehaviour
    {
        [SerializeField] private Transform _target;
        [SerializeField] private FloatVariable _metersVariable;

        private void Update()
        {
            _metersVariable.Value = Mathf.Abs(_target.position.y);
        }
    }
}