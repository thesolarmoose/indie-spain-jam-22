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
            var depth = _target.position.y;
            _metersVariable.Value = -depth;
        }
    }
}